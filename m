Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934304AbaGPOmI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 10:42:08 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:45352 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932951AbaGPOmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 10:42:06 -0400
MIME-Version: 1.0
In-Reply-To: <20140716141842.GO17528@sirena.org.uk>
References: <1405510797-755-1-git-send-email-pramod.gurav.etc@gmail.com>
	<53C66AEB.7030906@mm-sol.com>
	<1405512867.75389776@apps.rackspace.com>
	<53C66F3B.9020507@mm-sol.com>
	<1405515375.452411340@apps.rackspace.com>
	<20140716135345.GA508@sirena.org.uk>
	<1405519254.31919.24.camel@iivanov-dev>
	<20140716141842.GO17528@sirena.org.uk>
Date: Wed, 16 Jul 2014 20:12:04 +0530
Message-ID: <CAMf-jSnqng1uFazZgxHKvEwaHssNwZJaJaUU7o+81uJ2oA9e5w@mail.gmail.com>
Subject: Re: [PATCH] regmap: Kconfig: Select SPMI when REGMAP_SPMI is selected
From: pramod gurav <pramod.gurav.etc@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Pramod Gurav <pramod.gurav@smartplayin.com>,
        Stanimir Varbanov <svarbanov@mm-sol.com>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Josh Cartwright <joshc@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2014 at 7:48 PM, Mark Brown <broonie@kernel.org> wrote:
> On Wed, Jul 16, 2014 at 05:00:54PM +0300, Ivan T. Ivanov wrote:
>> On Wed, 2014-07-16 at 14:53 +0100, Mark Brown wrote:
>
>> > No, this isn't an either/or thing - the dependency is absolutely
>> > mandatory if the device needs SPMI.  The defconfigs are a separate
>> > thing, they just exist to give people a starting point for configuring
>> > their kernel so if the device using SPMI is important for relevant
>> > systems the defconfig needs to be set up to enable it but that's
>> > separate to the dependency since there's no need for people to ever even
>> > look at defconfigs.
>
>> Then config REGMAP_SPMI should depend on SPMI, right?
>
> No, REGMAP_SPMI is not something that can be enabled directly - it is
> selected by its users which should be ensuring that SPMI is enabled as
> it is difficult to see a use case for REGMAP_SPMI which does not do
> this.
>
> A dependency from a selected symbol will have no effect.

Thanks Mark. So essentially in this case PMIC driver should 'select SPMI'.
Right?

-- 
Thanks and Regards
Pramod
