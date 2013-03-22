Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422985Ab3CVUmM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 16:42:12 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:47223 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422937Ab3CVUmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 16:42:10 -0400
Message-ID: <514CC21E.40206@wwwdotorg.org>
Date: Fri, 22 Mar 2013 14:42:06 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>
CC: Peter De Schrijver <pdeschrijver@nvidia.com>,
        linux-arm-kernel@lists.infradead.org,
        Prashant Gaikwad <pgaikwad@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH REPOST v2] clk: add table lookup to mux
References: <1363954078-29952-1-git-send-email-pdeschrijver@nvidia.com> <514C813E.1070603@wwwdotorg.org> <20130322202522.834.24639@quantum>
In-Reply-To: <20130322202522.834.24639@quantum>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2013 02:25 PM, Mike Turquette wrote:
> Quoting Stephen Warren (2013-03-22 09:05:18)
>> On 03/22/2013 06:07 AM, Peter De Schrijver wrote:
>>> Add a table lookup feature to the mux clock. Also allow arbitrary masks
>>> instead of the width. This will be used by some clocks on Tegra114. Also
>>> adapt the tegra periph clk because it uses struct clk_mux directly.
>>>
>>> Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
>>
>> Tested-by: Stephen Warren <swarren@nvidia.com>
> 
> Thanks for the patch.  Taken into clk-next.

Great. Recall this is a dependency for the Tegra114 clock series that I
was planning on taking through the Tegra tree. Should I just merge your
whole clk-next into the Tegra tree as a basis for the Tegra114 clock
branch, or should this one patch be put into a separate topic branch so
I don't pick up everything? The latter would reduce the
inter-dependencies, and allow the merge to happen earlier. Obviously,
I'll wait until you let me know the appropriate branch is stable before
doing the merge. Thanks.
