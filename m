Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759604Ab3JOS7y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 14:59:54 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:56870 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588Ab3JOS7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 14:59:52 -0400
Message-ID: <525D90A3.2040606@wwwdotorg.org>
Date: Tue, 15 Oct 2013 12:59:47 -0600
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
Subject: Re: [PATCH v3 05/19] clk: tegra: move some PLLC and PLLXC init to
 clk-pll.c
References: <1381848794-11761-1-git-send-email-pdeschrijver@nvidia.com> <1381848794-11761-6-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1381848794-11761-6-git-send-email-pdeschrijver@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2013 08:52 AM, Peter De Schrijver wrote:
> vco min clipping, dynamic ramp setup and IDDQ init can be done in the
> respective pll clk_register functions if the parent is already registered.
> This is done for other some PLLs already.

Nit: VCO and PLL should be capitalized in this commit description. Same
with HW in the next patch.

