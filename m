Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751327AbaFXD51 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 23:57:27 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:16582 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbaFXD50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 23:57:26 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 23 Jun 2014 20:47:41 -0700
Message-ID: <53A8F723.5070008@nvidia.com>
Date: Tue, 24 Jun 2014 12:57:23 +0900
From: Alexandre Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>
CC: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gnurou@gmail.com" <gnurou@gmail.com>
Subject: Re: [PATCH 0/2] ARM: tegra: roth: pinmux fixes
References: <1403508779-25896-1-git-send-email-acourbot@nvidia.com> <53A8760D.8080106@wwwdotorg.org>
In-Reply-To: <53A8760D.8080106@wwwdotorg.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2014 03:46 AM, Stephen Warren wrote:
> On 06/23/2014 01:32 AM, Alexandre Courbot wrote:
>> Two small but important fixes to SHIELD's pinmux configuration.
>> The use of invalid properties caused the pinmux to not be applied
>> at all. Also the setting for sdmmc clock lines resulted in random
>> errors or even the impossibility to probe attached devices.
>
> It might be nice to add Roth's pinmux to:
> https://github.com/NVIDIA/tegra-pinmux-scripts

Certainly - will keep a note to do it sometime soon. Thanks for pointing 
it out.
