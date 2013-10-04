Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157Ab3JDTfy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 15:35:54 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:35919 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213Ab3JDTfw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 15:35:52 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Mark Brown <broonie@kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <20131004164139.GR27287@sirena.org.uk>
Cc: mark.rutland@arm.com, devicetree@vger.kernel.org, pawel.moll@arm.com,
        ijc+devicetree@hellion.org.uk, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, rob.herring@calxeda.com, rob@landley.net,
        grant.likely@linaro.org, linux-arm-kernel@lists.infradead.org
References: <1380803407-15196-1-git-send-email-ldewangan@nvidia.com>
 <20131004164139.GR27287@sirena.org.uk>
Message-ID: <20131004193545.4343.15596@quantum>
User-Agent: alot/0.3.4
Subject: Re: [PATCH] clk: palmas: add clock driver for palmas
Date: Fri, 04 Oct 2013 12:35:45 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Mark Brown (2013-10-04 09:41:39)
> On Thu, Oct 03, 2013 at 06:00:07PM +0530, Laxman Dewangan wrote:
> 
> > +     Optional subnode properties:
> > +     ti,clock-boot-enable: Enable clock at the time of booting.
> 
> Shouldn't this be a generic clock subsystem thing?  It seems like
> something that might be desired for nearly any clock.

The best solution is to have a driver claim the clock with clk_get and
enable it with clk_prepare_enable. I gave more detail in my reply to
Laxman.

Regards,
Mike
