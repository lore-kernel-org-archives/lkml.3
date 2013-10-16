Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761188Ab3JPRC4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 13:02:56 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:43512 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761155Ab3JPRCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 13:02:53 -0400
Message-ID: <525EC6BA.4040709@wwwdotorg.org>
Date: Wed, 16 Oct 2013 11:02:50 -0600
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
        Hiroshi Doyu <hdoyu@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v3 14/19] clk: tegra30: replace enum by binding header
References: <1381848794-11761-1-git-send-email-pdeschrijver@nvidia.com> <1381848794-11761-15-git-send-email-pdeschrijver@nvidia.com> <525D9A85.40102@wwwdotorg.org> <20131016144618.GL5643@tbergstrom-lnx.Nvidia.com>
In-Reply-To: <20131016144618.GL5643@tbergstrom-lnx.Nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2013 08:46 AM, Peter De Schrijver wrote:
> On Tue, Oct 15, 2013 at 09:41:57PM +0200, Stephen Warren wrote:
>> On 10/15/2013 08:52 AM, Peter De Schrijver wrote:
>>> As the clock IDs are now specified in a header file, we can use those
>>> definitions instead of maintaining an internal enum.
>>
>> Nit: The patch subject should say "clk: tegra:" not "clk: tegra20:" so
>> that anyone looking at the tags in the subject has only one "tegra"
>> value to look at, not a whole bunch of them.
>>
>> Would it make sense to squash patches 15, 16, 18 together (and similar
>> for Tegra30) to avoid some churn i.e. the fact that the entire body of
>> tegra_periph_clk_list[] gets replaced twice?
> 
> You mean do all the changes for Tegra20 and Tegra30 in 1 patch per SoC?

Yes. I think it'd make the patches smaller. But it's probably not a big
deal if you disagree.

