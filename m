Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543Ab3J3WuJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 18:50:09 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:45512 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369Ab3J3WuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 18:50:07 -0400
Message-ID: <52718D1B.6030106@wwwdotorg.org>
Date: Wed, 30 Oct 2013 16:50:03 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Mike Turquette <mturquette@linaro.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>, Mark Zhang <markz@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] clk: tegra: use pll_ref as the pll_e parent
References: <1383093707-10312-1-git-send-email-pdeschrijver@nvidia.com> <527128B5.2020101@wwwdotorg.org> <20131030221833.GQ22111@tbergstrom-lnx.Nvidia.com>
In-Reply-To: <20131030221833.GQ22111@tbergstrom-lnx.Nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/30/2013 04:18 PM, Peter De Schrijver wrote:
> On Wed, Oct 30, 2013 at 04:41:41PM +0100, Stephen Warren wrote:
>> On 10/29/2013 06:41 PM, Peter De Schrijver wrote:
>>> Use pll_ref instead of pll_re_vco as the pll_e parent on Tegra114 and
>>> Tegra124. Also add a pll_ref table entry for pll_e for Tegra114.
>>
>> Why? What benefit does this give, or what bug does this fix?
> 
> Otherrwise Tegra114 will crash on boot.

Sigh. For what reason?
