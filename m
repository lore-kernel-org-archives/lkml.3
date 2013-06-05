Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756607Ab3FEQZ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 12:25:29 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:51536 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756521Ab3FEQZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 12:25:27 -0400
Message-ID: <51AF6674.3020701@wwwdotorg.org>
Date: Wed, 05 Jun 2013 10:25:24 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: linux-arm-kernel@lists.infradead.org, mturquette@linaro.org,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] PLL m,n,p init from SoC files
References: <1370440301-3562-1-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1370440301-3562-1-git-send-email-pdeschrijver@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2013 07:51 AM, Peter De Schrijver wrote:
> The m,n,p fields don't have the same bit offset and width across all PLLs.
> This patchset allows SoC specific files to indicate the offset and width.
> It also provides the data for Tegra114.

The series,
Tested-by: Stephen Warren <swarren@nvidia.com>
Acked-by: Stephen Warren <swarren@nvidia.com>

