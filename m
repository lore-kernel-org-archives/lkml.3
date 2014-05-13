Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083AbaEMT50 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 15:57:26 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:43085 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556AbaEMT5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 15:57:17 -0400
Message-ID: <5372791A.4080909@wwwdotorg.org>
Date: Tue, 13 May 2014 13:57:14 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: stefan@agner.ch, thierry.reding@gmail.com
CC: linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, marcel@ziswiler.com
Subject: Re: [PATCH 1/2] ARM: tegra: enable MCP251x CAN controller and DS1307
 RTC
References: <cover.1400001937.git.stefan@agner.ch> <77cfca0a1769d867c8d2919f0040fbd785940fef.1400001937.git.stefan@agner.ch>
In-Reply-To: <77cfca0a1769d867c8d2919f0040fbd785940fef.1400001937.git.stefan@agner.ch>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2014 11:27 AM, stefan@agner.ch wrote:
> From: Stefan Agner <stefan@agner.ch>
> 
> Toradex Colibri Evaluation Board uses the DS1307 RTC and the
> MCP251x CAN controller. The NVIDIA Tegra 3 based Colibri T30
> module can be used on this carrier board, hence enable those
> drivers in tegra_defonfig.
> 
> Furthermore the NVIDIA Tegra 3 based Apalis T30 module too
> contains two MCP251x CAN controller.

I have squashed this patch into Tegra's for-3.16/defconfig branch.

Can you please also send a patch to enable the same options in
multi_v7_defconfig. Send that to arm@kernel.org (it's an alias for the
armsoc tree maintainers). That will ensure that anyone using that config
will also get these changes.

Thanks.
