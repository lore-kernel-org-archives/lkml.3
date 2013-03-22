Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422643Ab3CVRhV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 13:37:21 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:56814 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422636Ab3CVRhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 13:37:19 -0400
Message-ID: <514C96CC.8000904@wwwdotorg.org>
Date: Fri, 22 Mar 2013 11:37:16 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: swarren@nvidia.com, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH V2 0/4] ARM: tegra: dalmore: add regulators
References: <1363873663-19272-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1363873663-19272-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2013 07:47 AM, Laxman Dewangan wrote:
> This series add the regulators for Dalmore platform.
> Dalmore also have the Palma PMIC as primary PMIC but 
> dt population will be send later once DT documentation
> finalize.

The series is applied. The first 3 patches to Tegra's for-3.10/dt
branch, and patch 4 to Tegra's for-3.10/defconfig banch.

In patch 2,

> +		tps65090@48 {

I removed "@48" there, since the unit-address isn't required to make the
node name unique.
