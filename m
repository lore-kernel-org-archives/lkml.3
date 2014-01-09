Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454AbaAILFC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 06:05:02 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:5633 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbaAILEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 06:04:54 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 09 Jan 2014 03:05:13 -0800
Message-ID: <52CE821F.6030908@nvidia.com>
Date: Thu, 9 Jan 2014 16:33:59 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: config: enable ams AS3722 power reset driver
References: <1389084000-17033-1-git-send-email-ldewangan@nvidia.com> <52CDA181.4030005@wwwdotorg.org>
In-Reply-To: <52CDA181.4030005@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 09 January 2014 12:35 AM, Stephen Warren wrote:
> On 01/07/2014 01:39 AM, Laxman Dewangan wrote:
>> ams AS3722 is used as system PMIC for Tegra124 based Venice2.
>> Enable ams AS3722 power reset driver for enabling power off
>> system using PMIC.
> I assume you'll also send a patch to add the following to DT:
>
> 			ams,system-power-controller;
>
Oops, I missed it.
Sent it.
