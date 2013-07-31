Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758478Ab3GaGLr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 02:11:47 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:2691 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758076Ab3GaGLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 02:11:45 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 30 Jul 2013 23:10:20 -0700
Message-ID: <51F8AD86.20905@nvidia.com>
Date: Wed, 31 Jul 2013 11:54:06 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH] pinctrl: tegra: add valid function name on DT document
References: <1375182261-30946-1-git-send-email-ldewangan@nvidia.com> <51F802F0.3030907@wwwdotorg.org>
In-Reply-To: <51F802F0.3030907@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 July 2013 11:46 PM, Stephen Warren wrote:
> On 07/30/2013 05:04 AM, Laxman Dewangan wrote:
>> Add valid property name for the property "nvidia,function" in
>> DT binding document of Tegra pincontrol.
> I have applied this to Tegra's for-3.12/dt branch, but I fixed up quite
> a few issues along the way...
>

Thank you very much for taking care.
