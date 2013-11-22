Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932080Ab3KVQU5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 11:20:57 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:43576 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754973Ab3KVQUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 11:20:55 -0500
Message-ID: <528F8462.4010105@wwwdotorg.org>
Date: Fri, 22 Nov 2013 09:20:50 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Alexandre Courbot <acourbot@nvidia.com>
CC: Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] clk: tegra: add FUSE clock device
References: <1385001490-18927-1-git-send-email-acourbot@nvidia.com> <20131122134140.GE26617@tbergstrom-lnx.Nvidia.com>
In-Reply-To: <20131122134140.GE26617@tbergstrom-lnx.Nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/22/2013 06:41 AM, Peter De Schrijver wrote:
> On Thu, Nov 21, 2013 at 03:38:10AM +0100, Alexandre Courbot wrote:
>> This clock is needed to ensure the FUSE registers can be accessed
>> without freezing the system.
>>
>> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> 
> Acked-by: Peter De Schrijver <pdeschrijver@nvidia.com>

Aren't you taking this patch through the clock tree?
