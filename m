Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755702Ab3HBTcj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 15:32:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44886 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754066Ab3HBTci (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 15:32:38 -0400
Date: Fri, 2 Aug 2013 21:27:13 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Zach Levis <zml@linux.vnet.ibm.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Evgeniy Polyakov <zbr@ioremap.net>,
        Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] exec: more cleanups
Message-ID: <20130802192713.GA9543@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On top of "[PATCH 0/3] exec: minor cleanups + minor fix" I sent
yesterday.

Perhaps too many patches for the poor search_binary_handler(),
but I do not know how to document the changes if I join them.

Oleg.

 fs/exec.c |   82 ++++++++++++++++++++++++++----------------------------------
 1 files changed, 36 insertions(+), 46 deletions(-)

