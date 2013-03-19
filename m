Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933323Ab3CSTyB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 15:54:01 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:41935 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933078Ab3CSTx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 15:53:59 -0400
Message-ID: <5148C253.6030007@wwwdotorg.org>
Date: Tue, 19 Mar 2013 13:53:55 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Venu Byravarasu <vbyravarasu@nvidia.com>
CC: gregkh@linuxfoundation.org, stern@rowland.harvard.edu, balbi@ti.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 2/7] ARM: tegra: update device trees for USB binding rework
References: <1363609781-4045-1-git-send-email-vbyravarasu@nvidia.com> <1363609781-4045-3-git-send-email-vbyravarasu@nvidia.com>
In-Reply-To: <1363609781-4045-3-git-send-email-vbyravarasu@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/2013 06:29 AM, Venu Byravarasu wrote:
> This patch updates all Tegra board files so that they contain all the
> properties required by the updated USB DT binding. Note that this patch
> only adds the new properties and does not yet remove the old properties,
> in order to maintain bisectability. The old properties will be removed
> once the driver has been updated to assume the new bindings.
> 
> Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
> ---
>  arch/arm/boot/dts/tegra20-colibri-512.dtsi |    4 +++
>  arch/arm/boot/dts/tegra20-harmony.dts      |    8 +++---
>  arch/arm/boot/dts/tegra20-iris-512.dts     |    4 +++
>  arch/arm/boot/dts/tegra20-paz00.dts        |    8 +++---
>  arch/arm/boot/dts/tegra20-seaboard.dts     |   13 +++++++---
>  arch/arm/boot/dts/tegra20-trimslice.dts    |   12 +++++++---
>  arch/arm/boot/dts/tegra20-ventana.dts      |    7 +++--
>  arch/arm/boot/dts/tegra20.dtsi             |   32 +++++++++++++++++----------
>  8 files changed, 57 insertions(+), 31 deletions(-)

I think you forgot to update arch/arm/boot/dts/tegra20-whistler.dts in
this patch.
