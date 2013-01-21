Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255Ab3AUNzb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 08:55:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10178 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754120Ab3AUNz1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 08:55:27 -0500
Date: Mon, 21 Jan 2013 08:09:51 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Amit Kale <akale@stec-inc.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
        device-mapper development <dm-devel@redhat.com>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        "kent.overstreet@gmail.com" <kent.overstreet@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "lsf-pc@lists.linux-foundation.org" 
	<lsf-pc@lists.linux-foundation.org>,
        Joe Thornber <ejt@redhat.com>
Subject: Re: [LSF/MM TOPIC] Re: [dm-devel] Announcement: STEC EnhanceIO SSD
 caching software for Linux kernel
Message-ID: <20130121130951.GA16574@redhat.com>
References: <50F844A3.9020300@warr.net>
 <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D72F1@MYMBX.MY.STEC-INC.AD>
 <50F970A3.4000403@warr.net>
 <20130118161135.GA3118@raspberrypi>
 <50F97C0F.9010405@warr.net>
 <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D7345@MYMBX.MY.STEC-INC.AD>
 <50F9963A.2080608@warr.net>
 <20130118212543.GB6425@blackbox.djwong.org>
 <20130118213759.GA30278@redhat.com>
 <C4B5704C6FEB5244B2A1BCC8CF83B86B0A624D5D4D@MYMBX.MY.STEC-INC.AD>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C4B5704C6FEB5244B2A1BCC8CF83B86B0A624D5D4D@MYMBX.MY.STEC-INC.AD>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21 2013 at 12:26am -0500,
Amit Kale <akale@stec-inc.com> wrote:

> > -----Original Message-----
> > From: Mike Snitzer [mailto:snitzer@redhat.com]
> > Sent: Saturday, January 19, 2013 3:08 AM
> > To: Darrick J. Wong
> > Cc: device-mapper development; Amit Kale; linux-bcache@vger.kernel.org;
> > kent.overstreet@gmail.com; LKML; lsf-pc@lists.linux-foundation.org; Joe
> > Thornber
> > Subject: Re: [LSF/MM TOPIC] Re: [dm-devel] Announcement: STEC EnhanceIO
> > SSD caching software for Linux kernel
> > 
> > On Fri, Jan 18 2013 at  4:25pm -0500,
> > Darrick J. Wong <darrick.wong@oracle.com> wrote:
> > 
> > > Since Joe is putting together a testing tree to compare the three
> > > caching things, what do you all think of having a(nother) session
> > > about ssd caching at this year's LSFMM Summit?
> > >
> > > [Apologies for hijacking the thread.]
> > > [Adding lsf-pc to the cc list.]
> > 
> > Hopefully we'll have some findings on the comparisons well before LSF
> > (since we currently have some momentum).  But yes it may be worthwhile
> > to discuss things further and/or report findings.
> 
> We should have performance comparisons presented well before the
> summit. It'll be good to have ssd caching session in any case. The
> likelihood that one of them will be included in Linux kernel before
> April is very low.

dm-cache is under active review for upstream inclusion.  I wouldn't
categorize the chances of dm-cache going upstream when the v3.9 merge
window opens as "very low".  But even if dm-cache does go upstream it
doesn't preclude bcache and/or enhanceio from going upstream too.
