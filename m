Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782AbbAUWc5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 17:32:57 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:39346 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526AbbAUWcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 17:32:47 -0500
From: Gabriele Mazzotta <gabriele.mzt@gmail.com>
To: Darren Hart <dvhart@infradead.org>
Cc: mjg59@srcf.ucam.org, pali.rohar@gmail.com, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org, A.Sloman@cs.bham.ac.uk,
        computersforpeace@gmail.com
Subject: Re: [PATCH] dell-laptop: use dedicated sysfs file for ALS
Date: Wed, 21 Jan 2015 23:32:44 +0100
Message-ID: <3002254.JbysBTROfI@xps13>
In-Reply-To: <20150121183823.GE7386@vmdeb7>
References: <1421244357-31103-1-git-send-email-gabriele.mzt@gmail.com> <1663320.Wk1Y30OHLH@xps13> <20150121183823.GE7386@vmdeb7>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 January 2015 10:38:23 Darren Hart wrote:
> On Sun, Jan 18, 2015 at 07:34:17PM +0100, Gabriele Mazzotta wrote:
> > On Sunday 18 January 2015 10:08:21 Darren Hart wrote:
> > > On Wed, Jan 14, 2015 at 03:07:21PM +0100, Gabriele Mazzotta wrote:
> > > > Hi,
> > > > 
> > > > I decided to remove "als" from input_triggers and created a dedicated
> > > > sysfs file for it. Having it there was wrong and misleading.
> > > > I also updated the documentation to reflect this change and fixed the
> > > > wrong description of als_setting, now used for als_enabled.
> > > 
> > > Given this is a significant functional change, as opposed to a bug fix, I'm
> > > leaning toward reverting the original and adding back the corrected version to
> > > 3.20. I'm going to look at the total impact first - let me know if you have a
> > > strong argument one way or the other.
> > 
> > I'm not against this decision.
> > If you do, please remember to also revert the commit that added the
> > documentation.
> 
> Then for my pull request to Linus this week, I'll be reverting:
> 
> 02b2aaa platform: x86: dell-laptop: Add support for keyboard backlight
> 3161293 Documentation: Add entry for dell-laptop sysfs interface
> 
> Am I missing anything?

No, that's all.

Thanks,
Gabriele
