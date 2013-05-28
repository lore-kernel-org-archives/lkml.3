Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934519Ab3E1PRB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 11:17:01 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:50544 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934418Ab3E1PRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 11:17:00 -0400
Message-ID: <51A4CA6A.8090103@wwwdotorg.org>
Date: Tue, 28 May 2013 09:16:58 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Prashant Gaikwad <pgaikwad@nvidia.com>
CC: mturquette@linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] clk: tegra: Use common of_clk_init function
References: <1369640409-1981-1-git-send-email-pgaikwad@nvidia.com>
In-Reply-To: <1369640409-1981-1-git-send-email-pgaikwad@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27/2013 01:40 AM, Prashant Gaikwad wrote:
> Use common of_clk_init() function for clocks initialization.

Acked-by: Stephen Warren <swarren@nvidia.com>
