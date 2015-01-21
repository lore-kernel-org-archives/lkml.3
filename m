Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482AbbAUSig (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 13:38:36 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:48811 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144AbbAUSi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 13:38:28 -0500
Date: Wed, 21 Jan 2015 10:38:23 -0800
From: Darren Hart <dvhart@infradead.org>
To: Gabriele Mazzotta <gabriele.mzt@gmail.com>
Cc: mjg59@srcf.ucam.org, pali.rohar@gmail.com, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org, A.Sloman@cs.bham.ac.uk,
        computersforpeace@gmail.com
Subject: Re: [PATCH] dell-laptop: use dedicated sysfs file for ALS
Message-ID: <20150121183823.GE7386@vmdeb7>
References: <1421244357-31103-1-git-send-email-gabriele.mzt@gmail.com>
 <9352624.oIKUSW0aDp@xps13>
 <20150118180821.GB56582@vmdeb7>
 <1663320.Wk1Y30OHLH@xps13>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1663320.Wk1Y30OHLH@xps13>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 18, 2015 at 07:34:17PM +0100, Gabriele Mazzotta wrote:
> On Sunday 18 January 2015 10:08:21 Darren Hart wrote:
> > On Wed, Jan 14, 2015 at 03:07:21PM +0100, Gabriele Mazzotta wrote:
> > > Hi,
> > > 
> > > I decided to remove "als" from input_triggers and created a dedicated
> > > sysfs file for it. Having it there was wrong and misleading.
> > > I also updated the documentation to reflect this change and fixed the
> > > wrong description of als_setting, now used for als_enabled.
> > 
> > Given this is a significant functional change, as opposed to a bug fix, I'm
> > leaning toward reverting the original and adding back the corrected version to
> > 3.20. I'm going to look at the total impact first - let me know if you have a
> > strong argument one way or the other.
> 
> I'm not against this decision.
> If you do, please remember to also revert the commit that added the
> documentation.

Then for my pull request to Linus this week, I'll be reverting:

02b2aaa platform: x86: dell-laptop: Add support for keyboard backlight
3161293 Documentation: Add entry for dell-laptop sysfs interface

Am I missing anything?

-- 
Darren Hart
Intel Open Source Technology Center
