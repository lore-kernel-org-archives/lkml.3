Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932576Ab3CSQDn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 12:03:43 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:33821 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755665Ab3CSQDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 12:03:41 -0400
Date: Tue, 19 Mar 2013 08:59:45 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: Rhyland Klein <rklein@nvidia.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: Re: [Patch v3 0/4] Add support for tps65090-charger
Message-ID: <20130319155945.GA17614@lizard.gateway.2wire.net>
References: <1363126089-9071-1-git-send-email-rklein@nvidia.com>
 <20130319022402.GA14118@lizard.gateway.2wire.net>
 <51488A75.6000003@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <51488A75.6000003@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 19, 2013 at 11:55:33AM -0400, Rhyland Klein wrote:
> On 3/18/2013 10:24 PM, Anton Vorontsov wrote:
> > On Tue, Mar 12, 2013 at 06:08:05PM -0400, Rhyland Klein wrote:
> >> This patchset adds support for the TPS65090-charger. This charger is
> >> registered as a subdevice of the TPS65090 PMIC.
> >>
> >> This series includes a fix for the tps65090 header file where all
> >> the interrupts were shifted by 1.
> > 
> > Thanks for the patches, Rhyland! 3/4 and 4/4 applied to the
> > battery-2.6.git tree.
> > 
> I was planning on posting a slightly changed v4 sometime soon which took
> care of some concerns on the Documentation and added a compatibility
> entry for the charger. Do you want me to send that still and you can
> replace v3 with v4?

I would rather avoid replacing, i.e. I'd prefer if you send an update on
top of the v3 (incremental patch). If the changes were inspired by
someone, feel free to add a Suggested-by: tag. ;-)

Thanks!

Anton
