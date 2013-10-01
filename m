Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751985Ab3JAT4c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 15:56:32 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:34107 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994Ab3JAT4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 15:56:30 -0400
Message-ID: <524B28EA.40702@wwwdotorg.org>
Date: Tue, 01 Oct 2013 13:56:26 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Mike Turquette <mturquette@linaro.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clk: tegra: PLLE spread spectrum control
References: <1380209654-25458-1-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1380209654-25458-1-git-send-email-pdeschrijver@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2013 09:34 AM, Peter De Schrijver wrote:
> Add spread spectrum control for PLLE in Tegra114.

It would be useful to have some description of the end-user-visible
benefit of this change; why is it useful?

Tested-by: Stephen Warren <swarren@nvidia.com>
(on Beaver and Harmony, a PCIe Ethernet NIC passes traffic just fine).
