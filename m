Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759385Ab3CGQId (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 11:08:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47872 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753057Ab3CGQIc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 11:08:32 -0500
Subject: Re: [PATCH -v2] gfs2: fix bitmap declaration
From: Steven Whitehouse <swhiteho@redhat.com>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, cluster-devel@redhat.com,
        Christine Caulfield <ccaulfie@redhat.com>,
        David Teigland <teigland@redhat.com>
In-Reply-To: <CAC5umyjw3xzdExvf3TA6i3iH=ortPeJivetUpEyCP5Mzmn6wEg@mail.gmail.com>
References: <1362576597-18501-1-git-send-email-akinobu.mita@gmail.com>
	 <1362583679.2707.21.camel@menhir>
	 <CAC5umyjw3xzdExvf3TA6i3iH=ortPeJivetUpEyCP5Mzmn6wEg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Thu, 07 Mar 2013 16:06:39 +0000
Message-ID: <1362672399.2528.32.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 2013-03-07 at 23:38 +0900, Akinobu Mita wrote:
> 2013/3/7 Steven Whitehouse <swhiteho@redhat.com>:
> > Hi,
> >
> > This doesn't apply over the patch which Dave just sent. Can you redo
> > this against the current GFS2 -nmw tree if it is still required? Thanks,
> 
> I checked Dave's patch.  It fixes the same issue that I was trying to fix.
> So this -v2 patch is not needed anymore.
> 
> But the cleanup patch in v1 ([PATCH 2/2] gfs2: use memchr_inv) is still
> applicable. So I'll resend it soon.

Ok, thanks. I've pushed the memchr_inv patch into the -nmw git tree,

Steve.


