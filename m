Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519Ab3CFGPL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 01:15:11 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:54170 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788Ab3CFGPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 01:15:08 -0500
X-AuditID: 9c930197-b7cc2ae000000eb7-8e-5136dee9d224
Date: Wed, 6 Mar 2013 15:15:05 +0900
From: Kyungsik Lee <kyungsik.lee@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Russell King <linux@arm.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, x86@kernel.org,
        celinux-dev@lists.celinuxforum.org, Nicolas Pitre <nico@fluxnic.net>,
        David Sterba <dsterba@suse.cz>, Nitin Gupta <nitingupta910@gmail.com>,
        Joe Millenbach <jmillenbach@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Michal Marek <mmarek@suse.cz>,
        hyojun.im@lge.com, chan.jeong@lge.com, raphael.andy.lee@gmail.com
Subject: Re: [PATCH v3 -next 0/5] Add support for LZ4-compressed kernel
Message-ID: <20130306061505.GA4979@Corona>
References: <1362484056-9778-1-git-send-email-kyungsik.lee@lge.com>
 <20130305150616.cb737f9b217b8c82051b2ccb@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130305150616.cb737f9b217b8c82051b2ccb@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 05, 2013 at 03:06:16PM -0800, Andrew Morton wrote:
> On Tue,  5 Mar 2013 20:47:31 +0900 Kyungsik Lee <kyungsik.lee@lge.com> wrote:
> 
> > This is the third version. In this version, Some codes are fixed
> > and more description and note are added. I would like to thank David Sterba
> > for his review.
> > 
> > The Last patch[5/5] of the patch set is for making x86 and arm default to
> > LZ4-compressed for testing the LZ4 code in the linux-next.
> > It was requested by Andrew Morton in the patch set v2.
> > 
> > Currently, A preliminary version of LZ4 de/compression tool is supported.
> > However, It is expected that we will have a tool with more features
> > once its format is finished.
> 
> What happened to the changelog?  The earlier version at least had some
> rudimentary benchmarking results, but now we don't even have that. 
> 
> Someone should prepare the information explaining why we added this to
> Linux, and I'd prefer that person be you rather than me!  Certainly it
> should include performance measurements - both speed and space.  Also
> it should capture our thinking regarding all the other decompressors,
> explaining why we view it as acceptable to add yet another one.
Sorry, It will have all the information you mentioned. I can reply to
this thread if you want.

Or I might need another patch(v4). I have one thing to be confirmed
regarding LZ4 format. One of the patch set needs to be fixed
if there is a change. After that I can include the information
in the changelog.

> Please, put yourself in the position of someone reading these commits
> in 2017 wondering "why did they merge this".  We should tell them.

Thanks,
Kyungsik
