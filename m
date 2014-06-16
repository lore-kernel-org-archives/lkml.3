Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932559AbaFPSO2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 14:14:28 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:38222 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754571AbaFPSO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 14:14:26 -0400
Message-ID: <539F33FE.8040501@wwwdotorg.org>
Date: Mon, 16 Jun 2014 12:14:22 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>, Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, olof@lixom.net
CC: mark.rutland@arm.com, devicetree@vger.kernel.org, linux@arm.linux.org.uk,
        pawel.moll@arm.com, ijc+devicetree@hellion.org.uk,
        linux-kernel@vger.kernel.org, robh+dt@kernel.org, galak@codeaurora.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/3] ARM: dts: Create a cros-ec-keyboard fragment
References: <1401920421-25729-1-git-send-email-dianders@chromium.org>
In-Reply-To: <1401920421-25729-1-git-send-email-dianders@chromium.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2014 04:20 PM, Doug Anderson wrote:
> All ChromeOS ARM devices that have the standard "CrOS EC" have the
> same keyboard mapping.  It's silly to include this same definition
> everywhere.  Let's create a "dtsi" fragment that we can include from
> many different boards.
> 
> This fragment is based on what's currently in tegra124-venice2.dts

I've applied this series to Tegra's for-3.17/dt-cros-ec-kbd branch. I'll
send a pull request to arm-soc shortly.
