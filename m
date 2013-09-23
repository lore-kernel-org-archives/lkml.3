Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356Ab3IWRw3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 13:52:29 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:35807 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684Ab3IWRw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 13:52:28 -0400
Message-ID: <52407FD8.3020509@wwwdotorg.org>
Date: Mon, 23 Sep 2013 11:52:24 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Mike Turquette <mturquette@linaro.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Joseph Lo <josephl@nvidia.com>, Paul Walmsley <pwalmsley@nvidia.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH 03/12] clk: tegra: Add TEGRA_PERIPH_NO_DIV flag
References: <1379515331-19427-1-git-send-email-pdeschrijver@nvidia.com> <1379515331-19427-4-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1379515331-19427-4-git-send-email-pdeschrijver@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18/2013 08:40 AM, Peter De Schrijver wrote:
> This flag indicates the peripheral clock does not have a divider. It will
> simply the initialization tables and avoids some very similar code.

s/simply/simplify/

