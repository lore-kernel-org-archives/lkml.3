Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756376Ab3FEQWK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 12:22:10 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:35046 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756044Ab3FEQWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 12:22:06 -0400
Message-ID: <51AF65AA.2000702@wwwdotorg.org>
Date: Wed, 05 Jun 2013 10:22:02 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: linux-arm-kernel@lists.infradead.org, mturquette@linaro.org,
        Prashant Gaikwad <pgaikwad@nvidia.com>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clk: tegra: pllc and pllxc should use pdiv_map
References: <1370437007-25596-1-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1370437007-25596-1-git-send-email-pdeschrijver@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2013 06:56 AM, Peter De Schrijver wrote:
> The pllc and pllxc code weren't always using the correct pdiv_map to
> map between the post divider value and the hw p field. This could result
> in illegal values being programmed in the hw.

Tested-by: Stephen Warren <swarren@nvidia.com>
Acked-by: Stephen Warren <swarren@nvidia.com>
