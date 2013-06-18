Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933672Ab3FRS2Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 14:28:16 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:52349 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933030Ab3FRS2O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 14:28:14 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Paul Walmsley <pwalmsley@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <alpine.DEB.2.02.1306172019270.17176@utopia.booyaka.com>
Cc: Prashant Gaikwad <pgaikwad@nvidia.com>, Aleksandr Frid <afrid@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Walmsley <pwalmsley@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
References: <20130607121505.21868.72360.stgit@dusk.lan>
 <20130607121901.21868.65416.stgit@dusk.lan> <51B21105.1080301@wwwdotorg.org>
 <alpine.DEB.2.02.1306071703050.7753@utopia.booyaka.com>
 <51B6D239.5030905@nvidia.com>
 <alpine.DEB.2.02.1306110944130.22645@utopia.booyaka.com>
 <20130616042256.7541.7096@quantum>
 <alpine.DEB.2.02.1306172019270.17176@utopia.booyaka.com>
Message-ID: <20130618182808.9136.26244@quantum>
User-Agent: alot/0.3.4
Subject: Re: [PATCH 3/3] clk: tegra: T114: add DFLL DVCO reset control
Date: Tue, 18 Jun 2013 11:28:08 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Paul Walmsley (2013-06-17 13:22:48)
> Hi,
> 
> On Sat, 15 Jun 2013, Mike Turquette wrote:
> 
> > These patches appear fine to me but I did not see any Acks, nor could I
> > tell if a v2 was necessary based on the comments. Will there be another
> > version?
> 
> I'm not planning to do another version at this time.

Thanks for clarifying.  I couldn't tell based on the discussion.

Anyways I've taken these into clk-next now.  There is not maintainer for
that directory as you pointed out, so no need to wait for Acks.

Regards,
Mike

> 
> > If not an Acked-by or Reviewed-by would be cool.
> 
> Hmm, not sure who the right people would be.  Looks like the 
> drivers/clk/tegra directory is unmaintained, so not sure who could ack it?
> 
> Peter or Stephen, care to review these patches and send a Reviewed-by?
> 
> 
> - Paul
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
