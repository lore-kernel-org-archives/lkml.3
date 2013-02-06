Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756839Ab3BFRhI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 12:37:08 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:36480 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754987Ab3BFRhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 12:37:05 -0500
Message-ID: <511294BC.1020808@wwwdotorg.org>
Date: Wed, 06 Feb 2013 10:37:00 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>
CC: Laxman Dewangan <ldewangan@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH] clk: tegra: initialise parent of uart clocks
References: <1360147661-5435-1-git-send-email-ldewangan@nvidia.com> <20130206122239.GH3073@tbergstrom-lnx.Nvidia.com>
In-Reply-To: <20130206122239.GH3073@tbergstrom-lnx.Nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/2013 05:22 AM, Peter De Schrijver wrote:
> On Wed, Feb 06, 2013 at 11:47:41AM +0100, Laxman Dewangan wrote:
>> Initialise the parent of UARTs to PLLP and disabling clock by
>> default.
>>
> 
> I wonder if we should move the parent definitions to DT at some point.

I think that's what Prashant is going to work on next, right?
