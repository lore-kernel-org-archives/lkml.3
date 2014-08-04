Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752263AbaHDO4z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 10:56:55 -0400
Received: from smtp.nue.novell.com ([195.135.221.5]:39793 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868AbaHDO4x (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Mon, 4 Aug 2014 10:56:53 -0400
Date: Mon, 4 Aug 2014 22:56:40 +0800
From: joeyli <jlee@suse.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Takashi Iwai <tiwai@suse.de>, "Lee, Chun-Yi" <joeyli.kernel@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Hibernate: check unsafe page should not in e820 reserved
 region
Message-ID: <20140804145640.GE16024@linux-rxt1.site>
References: <1407148396-21405-1-git-send-email-jlee@suse.com>
 <s5hlhr4v32f.wl%tiwai@suse.de>
 <20140804130810.GA23098@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140804130810.GA23098@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel, 

Thanks for your review!

On Mon, Aug 04, 2014 at 03:08:11PM +0200, Pavel Machek wrote:
> > > +
> > > +	list_for_each_entry(region, &nosave_regions, list) {
> > > +		if (pfn >= region->start_pfn && pfn < region->end_pfn) {
> > > +			pr_err("PM: %#010llx in e820 nosave regsion: "
> 
> And while looking at it, this should probably be spelled "region".
>  
> ...plus maybe past part of changelog here into the comment?
> 

Oh, sorry for my typo! I will correct it and comment in next version. 

> Otherwise looks good to me, 
> 
> Acked-by: Pavel Machek <pavel@ucw.cz>
> 									Pavel

Regards
Joey Lee
