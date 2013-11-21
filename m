Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429Ab3KUUaH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 15:30:07 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:39239 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923Ab3KUUaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 15:30:03 -0500
Message-ID: <528E6D46.7090406@wwwdotorg.org>
Date: Thu, 21 Nov 2013 13:29:58 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Alexandre Courbot <acourbot@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>
CC: linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clk: tegra: add FUSE clock device
References: <1385001490-18927-1-git-send-email-acourbot@nvidia.com>
In-Reply-To: <1385001490-18927-1-git-send-email-acourbot@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/2013 07:38 PM, Alexandre Courbot wrote:
> This clock is needed to ensure the FUSE registers can be accessed
> without freezing the system.

Acked-by: Stephen Warren <swarren@nvidia.com>
