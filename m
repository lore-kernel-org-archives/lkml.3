Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756045Ab3LDThb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 14:37:31 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:38193 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755995Ab3LDTh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 14:37:28 -0500
Message-ID: <529F8475.2060507@wwwdotorg.org>
Date: Wed, 04 Dec 2013 12:37:25 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>, rob.herring@calxeda.com
CC: pawel.moll@arm.com, mark.rutland@arm.com, devicetree@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ashwini Ghuge <aghuge@nvidia.com>
Subject: Re: [PATCH] ARM: tegra: add port FF to GPIO ID's
References: <1384780241-31639-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1384780241-31639-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2013 06:10 AM, Laxman Dewangan wrote:
> NVIDIA Tegra124 supports has the new gpio port as GPIO_FF.
> Add the macro for this port name.

I've applied this to Tegra's for-3.14/dt branch.

