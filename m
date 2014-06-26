Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757306AbaFZPxW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 11:53:22 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:60873 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754519AbaFZPxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 11:53:21 -0400
Message-ID: <53AC41EE.7090103@wwwdotorg.org>
Date: Thu, 26 Jun 2014 09:53:18 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] clk: tegra124: init table updates
References: <1403796403-26443-1-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1403796403-26443-1-git-send-email-pdeschrijver@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2014 09:26 AM, Peter De Schrijver wrote:
> Ensure some clocks critical for system operation are always on. Also enable
> csite for JTAG debugging and set the tsensor clock frequency for the upcoming
> soctherm driver.

Acked-by: Stephen Warren <swarren@nvidia.com>
