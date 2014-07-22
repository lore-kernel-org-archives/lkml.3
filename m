Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882AbaGVUhH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 16:37:07 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:41547 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021AbaGVUhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 16:37:05 -0400
Message-ID: <53CECB6C.2030207@wwwdotorg.org>
Date: Tue, 22 Jul 2014 14:37:00 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: nick.dyer@itdev.co.uk
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Yufeng Shen <miletus@google.com>, Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Alan Bowens <Alan.Bowens@atmel.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Meerwald <pmeerw@pmeerw.net>,
        Benson Leung <bleung@chromium.org>,
        Olof Johansson <olofj@chromium.org>, Sekhar Nori <nsekhar@ti.com>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH 04/15] Input: atmel_mxt_ts - implement device tree support
References: <1404399697-26484-1-git-send-email-nick.dyer@itdev.co.uk> <1404399697-26484-5-git-send-email-nick.dyer@itdev.co.uk>
In-Reply-To: <1404399697-26484-5-git-send-email-nick.dyer@itdev.co.uk>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/03/2014 09:01 AM, nick.dyer@itdev.co.uk wrote:
> From: Stephen Warren <swarren@nvidia.com>

> diff --git a/Documentation/devicetree/bindings/input/atmel,maxtouch.txt b/Documentation/devicetree/bindings/input/atmel,maxtouch.txt

> +	touch@4b {
> +		compatible = "atmel,maxtouch";
> +		reg = <0x4b>;
> +		interrupt-parent = <&gpio>;
> +		interrupts = <TEGRA_GPIO(W, 3) GPIO_ACTIVE_HIGH>;

Oops. s/GPIO_ACTIVE_HIGH/IRQ_TYPE_LEVEL_LOW/ there; I evidently typed
something stupid into the doc when I wrote it!
