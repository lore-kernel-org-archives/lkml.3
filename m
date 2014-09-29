Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015AbaI2Nav (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 09:30:51 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:64786 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177AbaI2Nat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 09:30:49 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: zhang.lyra@gmail.com, catalin.marinas@arm.com, gregkh@linuxfoundation.org,
        ijc+devicetree@hellion.org.uk, jslaby@suse.cz, galak@codeaurora.org,
        broonie@linaro.org, mark.rutland@arm.com, m-karicheri2@ti.com,
        pawel.moll@arm.com, artagnon@gmail.com, rrichter@cavium.com,
        robh+dt@kernel.org, will.deacon@arm.com, orsonzhai@gmail.com,
        geng.ren@spreadtrum.com, zhizhou.zhang@spreadtrum.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] Documentation: Add entry for Spreadtrum's Shark64 SoC
Date: Mon, 29 Sep 2014 15:30:34 +0200
Message-ID: <7195852.7nSHtIu8oc@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1411992293-7729-7-git-send-email-zhang.lyra@gmail.com>
References: <1411992293-7729-1-git-send-email-zhang.lyra@gmail.com> <1411992293-7729-7-git-send-email-zhang.lyra@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:NyOmd6/4ORVxnSips9rRPLNuy+kTSlIGlCAn4en2JuF
 Z1mjlP+Wi23BLpLfC78lwXHJFOZIJ+oyA/yNgPseBEf4nblVaU
 AbNTuktu/T4F2wCfNR7CHToJ8QQomXyjhTyYmnALSOrojN5ZcK
 +nqu78sug50EFB9FNUKOaUPNt30n1xbCvtgvvKCKtg/o0HBU25
 E0KBQdR0nt5irFaCBvCYYOF9G31N5NhlFWnwsJXmi8o9xpnsn1
 8/LojrZ70ZrdTuiSodfXLTm5o51YOfj0H5VQ7YiGnTLiFlbEio
 2wuZlOmdv5bkqvARyDj77TWsnUDo1EVWE5usEYmVIiuILHn4Jw
 4C2me5cB1e/pxgHGs7rc=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 29 September 2014 20:04:53 zhang.lyra@gmail.com wrote:
> diff --git a/Documentation/devicetree/bindings/arm/sprd.txt b/Documentation/devicetree/bindings/arm/sprd.txt
> new file mode 100644
> index 0000000..b6dc143
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/arm/sprd.txt
> @@ -0,0 +1,6 @@
> +Spreadtrum Platforms Device Tree Bindings
> +----------------------------------------------------
> +
> +Shark64 Board
> +Required root node properties:
> +        - compatible = "sprd,shark64";
> 

Is Shark a board or an SOC? The subject line of the patch and the contents
seem to disagree here.

It's generally better to have the exact SoC product numbers in here, e.g.
"sprd,sc1234", in case we have to apply fixups based on the SoC. You should
also have a board specific string in addition to the SoC-specific one.

	Arnd
