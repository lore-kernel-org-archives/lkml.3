Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756716Ab3HATKY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 15:10:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41543 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754897Ab3HATKX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 15:10:23 -0400
Date: Thu, 1 Aug 2013 21:04:55 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Zach Levis <zml@linux.vnet.ibm.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Evgeniy Polyakov <zbr@ioremap.net>,
        Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] exec: minor cleanups + minor fix
Message-ID: <20130801190455.GA3194@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

By discussion with Zach, please drop

	fs-binfmts-add-a-name-field-to-the-binfmt-struct.patch
	fs-binfmts-better-handling-of-binfmt-loops.patch
	fs-binfmts-whitespace-fixes-with-scripts-cleanfile.patch

Zach is working on v2.

Meanwhile, can't we cleanup search_binary_handler() a bit? It
doesn't look nice imho. And we can certainly cleanup it more
(perhaps I'll try tomorrow). The error handling, request_module()
logic and even "for (try=0; try<2; try++)" looks horrible imho.

Oleg.

