Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934070AbaGPOBU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 10:01:20 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:59380 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759250AbaGPOBT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 10:01:19 -0400
Message-ID: <1405519254.31919.24.camel@iivanov-dev>
Subject: Re: [PATCH] regmap: Kconfig: Select SPMI when REGMAP_SPMI is
 selected
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Mark Brown <broonie@kernel.org>
Cc: Pramod Gurav <pramod.gurav@smartplayin.com>,
        Stanimir Varbanov <svarbanov@mm-sol.com>, pramod.gurav.etc@gmail.com,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Josh Cartwright <joshc@codeaurora.org>
Date: Wed, 16 Jul 2014 17:00:54 +0300
In-Reply-To: <20140716135345.GA508@sirena.org.uk>
References: <1405510797-755-1-git-send-email-pramod.gurav.etc@gmail.com>
	 <53C66AEB.7030906@mm-sol.com> <1405512867.75389776@apps.rackspace.com>
	 <53C66F3B.9020507@mm-sol.com> <1405515375.452411340@apps.rackspace.com>
	 <20140716135345.GA508@sirena.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.1-2ubuntu2~saucy1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-07-16 at 14:53 +0100, Mark Brown wrote:
> On Wed, Jul 16, 2014 at 06:26:15PM +0530, Pramod Gurav wrote:
> 
> Fix your mailer to word wrap within paragraphs, this will make your
> mails more legible - see Documentation/email-clients.txt.
> 
> > On Wednesday, 16 July, 2014 5:55pm, "Stanimir Varbanov" <svarbanov@mm-sol.com> said:
> 
> > The CONFIG_SPMI option is visible in menuconfig hence either it should
> > be set by default in multi_v7_defconfig(like in qcom_defconfig) or
> > driver owner should mention a 'depneds on CONFIG_SPMI' as suggested by
> > Lars-Peter Clausen. 
> 
> > I prefer the former (defconfig).
> 
> No, this isn't an either/or thing - the dependency is absolutely
> mandatory if the device needs SPMI.  The defconfigs are a separate
> thing, they just exist to give people a starting point for configuring
> their kernel so if the device using SPMI is important for relevant
> systems the defconfig needs to be set up to enable it but that's
> separate to the dependency since there's no need for people to ever even
> look at defconfigs.

Then config REGMAP_SPMI should depend on SPMI, right?

Regards,
Ivan

