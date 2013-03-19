Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757651Ab3CSC2T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 22:28:19 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:43436 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754529Ab3CSC2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 22:28:17 -0400
Date: Mon, 18 Mar 2013 19:24:02 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: Rhyland Klein <rklein@nvidia.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: Re: [Patch v3 0/4] Add support for tps65090-charger
Message-ID: <20130319022402.GA14118@lizard.gateway.2wire.net>
References: <1363126089-9071-1-git-send-email-rklein@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1363126089-9071-1-git-send-email-rklein@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 06:08:05PM -0400, Rhyland Klein wrote:
> This patchset adds support for the TPS65090-charger. This charger is
> registered as a subdevice of the TPS65090 PMIC.
> 
> This series includes a fix for the tps65090 header file where all
> the interrupts were shifted by 1.

Thanks for the patches, Rhyland! 3/4 and 4/4 applied to the
battery-2.6.git tree.

Anton
