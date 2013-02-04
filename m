Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305Ab3BDUde (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 15:33:34 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:56934 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755208Ab3BDUda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 15:33:30 -0500
Date: Mon, 4 Feb 2013 12:33:26 -0800
From: Kent Overstreet <koverstreet@google.com>
To: Mike Snitzer <snitzer@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
        device-mapper development <dm-devel@redhat.com>,
        Amit Kale <akale@stec-inc.com>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        "kent.overstreet@gmail.com" <kent.overstreet@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, lsf-pc@lists.linux-foundation.org,
        Joe Thornber <ejt@redhat.com>
Subject: Re: [LSF/MM TOPIC] Re: [dm-devel] Announcement: STEC EnhanceIO SSD
 caching software for Linux kernel
Message-ID: <20130204203326.GA21532@google.com>
References: <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D7248@MYMBX.MY.STEC-INC.AD>
 <50F844A3.9020300@warr.net>
 <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D72F1@MYMBX.MY.STEC-INC.AD>
 <50F970A3.4000403@warr.net>
 <20130118161135.GA3118@raspberrypi>
 <50F97C0F.9010405@warr.net>
 <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D7345@MYMBX.MY.STEC-INC.AD>
 <50F9963A.2080608@warr.net>
 <20130118212543.GB6425@blackbox.djwong.org>
 <20130118213759.GA30278@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130118213759.GA30278@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2013 at 04:37:59PM -0500, Mike Snitzer wrote:
> On Fri, Jan 18 2013 at  4:25pm -0500,
> Darrick J. Wong <darrick.wong@oracle.com> wrote:
> 
> > Since Joe is putting together a testing tree to compare the three caching
> > things, what do you all think of having a(nother) session about ssd caching at
> > this year's LSFMM Summit?
> > 
> > [Apologies for hijacking the thread.]
> > [Adding lsf-pc to the cc list.]
> 
> Hopefully we'll have some findings on the comparisons well before LSF
> (since we currently have some momentum).  But yes it may be worthwhile
> to discuss things further and/or report findings.

I'd be willing to go and talk a bit about bcache. Curious to hear more
about the dm caching stuff, too.
