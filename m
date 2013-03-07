Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932863Ab3CGOie (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 09:38:34 -0500
Received: from mail-ob0-f169.google.com ([209.85.214.169]:55062 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754294Ab3CGOid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 09:38:33 -0500
MIME-Version: 1.0
In-Reply-To: <1362583679.2707.21.camel@menhir>
References: <1362576597-18501-1-git-send-email-akinobu.mita@gmail.com>
	<1362583679.2707.21.camel@menhir>
Date: Thu, 7 Mar 2013 23:38:33 +0900
Message-ID: <CAC5umyjw3xzdExvf3TA6i3iH=ortPeJivetUpEyCP5Mzmn6wEg@mail.gmail.com>
Subject: Re: [PATCH -v2] gfs2: fix bitmap declaration
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, cluster-devel@redhat.com,
        Christine Caulfield <ccaulfie@redhat.com>,
        David Teigland <teigland@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/3/7 Steven Whitehouse <swhiteho@redhat.com>:
> Hi,
>
> This doesn't apply over the patch which Dave just sent. Can you redo
> this against the current GFS2 -nmw tree if it is still required? Thanks,

I checked Dave's patch.  It fixes the same issue that I was trying to fix.
So this -v2 patch is not needed anymore.

But the cleanup patch in v1 ([PATCH 2/2] gfs2: use memchr_inv) is still
applicable. So I'll resend it soon.
