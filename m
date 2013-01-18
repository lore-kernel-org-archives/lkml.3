Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150Ab3ARVif (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 16:38:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27809 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750761Ab3ARVie (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 16:38:34 -0500
Date: Fri, 18 Jan 2013 16:37:59 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: device-mapper development <dm-devel@redhat.com>,
        Amit Kale <akale@stec-inc.com>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        "kent.overstreet@gmail.com" <kent.overstreet@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, lsf-pc@lists.linux-foundation.org,
        Joe Thornber <ejt@redhat.com>
Subject: Re: [LSF/MM TOPIC] Re: [dm-devel] Announcement: STEC EnhanceIO SSD
 caching software for Linux kernel
Message-ID: <20130118213759.GA30278@redhat.com>
References: <20130117132620.GA2438@raspberrypi>
 <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D7248@MYMBX.MY.STEC-INC.AD>
 <50F844A3.9020300@warr.net>
 <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D72F1@MYMBX.MY.STEC-INC.AD>
 <50F970A3.4000403@warr.net>
 <20130118161135.GA3118@raspberrypi>
 <50F97C0F.9010405@warr.net>
 <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D7345@MYMBX.MY.STEC-INC.AD>
 <50F9963A.2080608@warr.net>
 <20130118212543.GB6425@blackbox.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130118212543.GB6425@blackbox.djwong.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18 2013 at  4:25pm -0500,
Darrick J. Wong <darrick.wong@oracle.com> wrote:

> Since Joe is putting together a testing tree to compare the three caching
> things, what do you all think of having a(nother) session about ssd caching at
> this year's LSFMM Summit?
> 
> [Apologies for hijacking the thread.]
> [Adding lsf-pc to the cc list.]

Hopefully we'll have some findings on the comparisons well before LSF
(since we currently have some momentum).  But yes it may be worthwhile
to discuss things further and/or report findings.

Mike
