Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362Ab3FQUWw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 16:22:52 -0400
Received: from utopia.booyaka.com ([74.50.51.50]:40577 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267Ab3FQUWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 16:22:50 -0400
Date: Mon, 17 Jun 2013 20:22:48 +0000 (UTC)
From: Paul Walmsley <pwalmsley@nvidia.com>
To: Mike Turquette <mturquette@linaro.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>
cc: Paul Walmsley <pwalmsley@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Aleksandr Frid <afrid@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 3/3] clk: tegra: T114: add DFLL DVCO reset control
In-Reply-To: <20130616042256.7541.7096@quantum>
Message-ID: <alpine.DEB.2.02.1306172019270.17176@utopia.booyaka.com>
References: <20130607121505.21868.72360.stgit@dusk.lan> <20130607121901.21868.65416.stgit@dusk.lan> <51B21105.1080301@wwwdotorg.org> <alpine.DEB.2.02.1306071703050.7753@utopia.booyaka.com> <51B6D239.5030905@nvidia.com> <alpine.DEB.2.02.1306110944130.22645@utopia.booyaka.com>
 <20130616042256.7541.7096@quantum>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, 15 Jun 2013, Mike Turquette wrote:

> These patches appear fine to me but I did not see any Acks, nor could I
> tell if a v2 was necessary based on the comments. Will there be another
> version?

I'm not planning to do another version at this time.

> If not an Acked-by or Reviewed-by would be cool.

Hmm, not sure who the right people would be.  Looks like the 
drivers/clk/tegra directory is unmaintained, so not sure who could ack it?

Peter or Stephen, care to review these patches and send a Reviewed-by?


- Paul
