Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944Ab3LSTW4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 14:22:56 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:37393 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677Ab3LSTWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 14:22:54 -0500
Message-ID: <52B3478A.2030405@wwwdotorg.org>
Date: Thu, 19 Dec 2013 12:22:50 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clk: tegra: Add missing Tegra20 fuse clks
References: <1387469676-17693-1-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1387469676-17693-1-git-send-email-pdeschrijver@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2013 09:14 AM, Peter De Schrijver wrote:

A patch description would be nice.

Acked-by: Stephen Warren <swarren@nvidia.com>

I assume this is going through the clock tree, and there aren't any
dependencies between this patch and the other series touching fuses that
showed up today? (or the dependencies will be resolved by deferring
dependant patches to 3.15...)

