Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932828Ab3IDULZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 16:11:25 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:33963 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761123Ab3IDULW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 16:11:22 -0400
Message-ID: <522793E7.3020000@wwwdotorg.org>
Date: Wed, 04 Sep 2013 14:11:19 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: linux-tegra@vger.kernel.org, Mike Turquette <mturquette@linaro.org>,
        Joseph Lo <josephl@nvidia.com>, Paul Walmsley <pwalmsley@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/4] Introduce table driven initializations
References: <1378304438-7780-1-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1378304438-7780-1-git-send-email-pdeschrijver@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2013 08:20 AM, Peter De Schrijver wrote:
> This patchset introduces a table driven initialization method for the
> audio, PMC and gate clocks. It's similar to the table we already have for                                                                                      
> the periph clocks.                                                                                                                                             
> 
> Changes since v1:
> 
> * Use parent names directly in TEGRA_INIT_DATA_GATE()

For the record, I said the following in response to V1 which still applies:

I assume these patches will all go through Mike's clock tree for 3.13.

Aside from the one issue I mentioned, the series,
Acked-by: Stephen Warren <swarren@nvidia.com>

I assume this will be followed by changes to convert the Tegra20/30
clock drivers to be table-based too?
