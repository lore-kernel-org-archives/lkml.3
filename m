Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759615Ab3JOTI6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 15:08:58 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:36325 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757185Ab3JOTI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 15:08:56 -0400
Message-ID: <525D92C3.9070507@wwwdotorg.org>
Date: Tue, 15 Oct 2013 13:08:51 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Hiroshi Doyu <hdoyu@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v3 09/19] clk: tegra: add clkdev registration infra
References: <1381848794-11761-1-git-send-email-pdeschrijver@nvidia.com> <1381848794-11761-10-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1381848794-11761-10-git-send-email-pdeschrijver@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2013 08:52 AM, Peter De Schrijver wrote:
> Add a common infra for registering clkdev. This allows decoupling clk
> registration from clkdev registration.

>  drivers/clk/tegra/clk-tegra114.c |  322 +++++++++++++++++++-------------------
>  drivers/clk/tegra/clk.c          |    9 +
>  drivers/clk/tegra/clk.h          |    7 +

It seems a little odd to have a patch which adds infra-structure and
converts Tegra114 alone, but not Tegra20/Tegra30. I would have expected
either:

* Patch to add infra-structure
* Patch to convert Tegra20
* Patch to convert Tegra30
* Patch to convert Tegra114

or:

* Patch to add infra-structure and convert Tegra20, Tegra30, and Tegra114.

Still, I suppose this isn't a particular problem, just something that
feels odd, so no need to split up all the patches to fit one of those
models. Just something to bear in mind next time.
