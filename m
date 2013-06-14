Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672Ab3FNTNZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 15:13:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11953 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752784Ab3FNTNY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 15:13:24 -0400
Date: Fri, 14 Jun 2013 21:09:15 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Andrey Vagin <avagin@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] fix ->shm_file leak
Message-ID: <20130614190915.GA8226@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

These 2 patches are completely orthogonal, and either patch can
fix the problem reported by Andrey. However, I think they both
make sense.

The 2nd patch was already acked by Eric/Andrey. However it is
not as trivial as it looks.

The 1st one looks more straightforward, and perhaps it is 3.10
material.

Oleg.

