Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933671Ab3FRSdZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 14:33:25 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:12081 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933020Ab3FRSdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 14:33:24 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 18 Jun 2013 11:31:48 -0700
Message-ID: <51C0A7EF.2020903@nvidia.com>
Date: Tue, 18 Jun 2013 11:33:19 -0700
From: Paul Walmsley <pwalmsley@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130518 Icedove/17.0.5
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>
CC: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Aleksandr Frid <afrid@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 3/3] clk: tegra: T114: add DFLL DVCO reset control
References: <20130607121505.21868.72360.stgit@dusk.lan> <20130607121901.21868.65416.stgit@dusk.lan> <51B21105.1080301@wwwdotorg.org> <alpine.DEB.2.02.1306071703050.7753@utopia.booyaka.com> <51B6D239.5030905@nvidia.com> <alpine.DEB.2.02.1306110944130.22645@utopia.booyaka.com> <20130616042256.7541.7096@quantum> <alpine.DEB.2.02.1306172019270.17176@utopia.booyaka.com> <20130618182808.9136.26244@quantum>
In-Reply-To: <20130618182808.9136.26244@quantum>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2013 11:28 AM, Mike Turquette wrote:
> Thanks for clarifying. I couldn't tell based on the discussion.

No worries :-)

> Anyways I've taken these into clk-next now. There is not maintainer 
> for that directory as you pointed out, so no need to wait for Acks.

Great, thanks.  Or if you'd prefer to wait for a Reviewed-by:, Peter 
mentioned today that he might take a look at them.  Either way is fine 
with me.


- Paul
