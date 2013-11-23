Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205Ab3KWR6R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 12:58:17 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:49944 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755806Ab3KWR6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 12:58:15 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: Fwd: [PATCH 7/8] watchdog: davinci: add "clocks" property
Date: Sat, 23 Nov 2013 18:57:46 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: "ivan.khoronzhuk" <ivan.khoronzhuk@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>, wim@iguana.be,
        nsekhar@ti.com, linux-watchdog@vger.kernel.org,
        devicetree@vger.kernel.org, mark.rutland@arm.com, pawel.moll@arm.com,
        swarren@wwwdotorg.org, ijc+devicetree@hellion.org.uk,
        galak@kernel.crashing.org, rob.herring@calxeda.com,
        linux-kernel@vger.kernel.org, grant.likely@linaro.org
References: <1383680783-12114-8-git-send-email-ivan.khoronzhuk@ti.com> <527A28E8.4010204@ti.com>
In-Reply-To: <527A28E8.4010204@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201311231857.47104.arnd@arndb.de>
X-Provags-ID: V02:K0:lxyj7VhoO2VRUdwFF1WjkzVoL7ytWsI433oIuOyUGmu
 Hw6HWL7hHYvB7AO20jbmzKAy6Hd9y5ImJjnSTARKCuC1sMHWD/
 quHFz9VHghYeUYppzYsSKPWMDsXfUnwLAaLqAJNxLnFJ8nZEuJ
 dN/r9Y7xFxbxYI29xwDqg185zPKIzZJ+jMQU+zIArPwz21wtL7
 Cblw5OT+1HPDpFzvubT3rMZxpp0URLlDDrqvNSlTsd3Yo2k2ts
 LinfAcdYvadTxe6RkMVZm4T1wVh5KdlGuzx0cmY8TP73AmA7Ui
 jIFtR3ft0hwacegwJWSIL1ypUZ/f3qKWIHpSFqhe1h9NMT9YCD
 Rz21gCMzSxJ7Q10QzWFE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 06 November 2013, ivan.khoronzhuk wrote:
> @@ -7,6 +7,10 @@ Required properties:
>  
>  - reg : Should contain WDT registers location and length
>  
> +- clocks: phandle reference to the controller clock.
> +         Required only for Keystone arch.
> +         See clock-bindings.txt
> +
>  Optional properties:
>  
>  - timeout-sec:         Contains the watchdog timeout in seconds

I think it should really be listed under "Optional properties" and the
reference to Keystone removed. Note how the binding would need
to change otherwise if another platform started to use the clock, which
is a little silly.

	Arnd
