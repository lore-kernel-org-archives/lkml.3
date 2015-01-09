Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758340AbbAIU7z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 15:59:55 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:44982 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736AbbAIU7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 15:59:53 -0500
Message-ID: <54B0417B.6030409@wwwdotorg.org>
Date: Fri, 09 Jan 2015 14:00:43 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Paul Walmsley <paul@pwsan.com>, Thierry Reding <thierry.reding@gmail.com>
CC: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexandre Courbot <gnurou@gmail.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Bill Huang <bilhuang@nvidia.com>, Stephen Boyd <sboyd@codeaurora.org>,
        Allen Martin <amartin@nvidia.com>,
        Paul Walmsley <pwalmsley@nvidia.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 4/4] clk: tegra: Add support for the Tegra132 CAR IP block
References: <20141216203813.22980.2301.stgit@chromeos-P9X79> <20141216203829.22980.64446.stgit@chromeos-P9X79> <20150109111954.GB16465@ulmo> <alpine.DEB.2.02.1501092030180.28771@utopia.booyaka.com>
In-Reply-To: <alpine.DEB.2.02.1501092030180.28771@utopia.booyaka.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2015 01:52 PM, Paul Walmsley wrote:
> Hi Thierry
>
> On Fri, 9 Jan 2015, Thierry Reding wrote:
>
>> On Tue, Dec 16, 2014 at 12:38:29PM -0800, Paul Walmsley wrote:
>>>
>>> This patch is based on several patches from others:
>>>
>>> 1. a  patch from Peter De Schrijver:
>>>
>>> http://lkml.iu.edu/hypermail/linux/kernel/1407.1/06094.html
>>>
>>> 2. a patch from Bill Huang ("clk: tegra: enable cclk_g at boot on
>>> Tegra132"), and
>>>
>>> 3. a patch from Allen Martin ("clk: Enable tegra clock driver for
>>> tegra132").
>>
>> Doesn't this technically require Signed-off-bys from each of the above,
>> then?
>
> I don't think so.  Documentation/SubmittingPatches states:

It's certainly been deemed acceptable in the past, if admittedly not 
optimal, for the person who is the "exit point" of an 
organization/company for the patch to be the only person to sign it off. 
The reason being they're vouching that the Certificate of Origin applies 
to all the company-sponsored work internal to the organization.
