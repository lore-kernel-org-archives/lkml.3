Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180AbaKKVkO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 16:40:14 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:53620 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741AbaKKVkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 16:40:11 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Feng Kan <fkan@apm.com>, patches@apm.com, jassisingbrar@gmail.com,
        =devicetree@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hieu Le <hnle@apm.com>
Subject: Re: [PATCH 5/6] Documentation: i2c: Add APM X-Gene platform SLIMpro I2C driver documentation
Date: Tue, 11 Nov 2014 22:40:01 +0100
Message-ID: <3205278.6fp3VTYkMI@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1412726809-7525-6-git-send-email-fkan@apm.com>
References: <1412726809-7525-1-git-send-email-fkan@apm.com> <1412726809-7525-6-git-send-email-fkan@apm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:iYBZAlTthioHV6LrF9tPvDbI/rWSfadeFg3SBP/87cx
 spOzyWvomyFrNumVnXb5HIQdJwJBjlJsbl+NTMi8fUrUO5UWNl
 8QXItKEc95sDsAVnuMXjadhivAm9xDW+M703jftyTVRShZPFPz
 HqJMYP2yA9ToAvhfrdOSHhkwu8hPTyPoJjOeJRgWVsdTlDkmU/
 AeC8bJJQodIV8hAY4Z1T+w0Di0e+0EZhytVcqQiYa96Qf6QPZG
 YOIKV4QClg36C2s0x+24Z0+Oy7rBlZTl6cSWC/fylQ5j7H/eP1
 +e67sc7Upqlo1gH2CObl9wZZWdQ23oecGd6ZfcxXprcktLOfQl
 iEPVptuaiW5y4tSIgwf4=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 October 2014 17:06:48 Feng Kan wrote:
> Add APM X-Gene platform SLIMpro I2C driver documentation.
> 

Don't just repeat the subject line, explain what this is for.

> Signed-off-by: Feng Kan <fkan@apm.com>
> Signed-off-by: Hieu Le <hnle@apm.com>
> ---
>  .../devicetree/bindings/i2c/i2c-xgene-slimpro.txt    | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/i2c/i2c-xgene-slimpro.txt
> 
> diff --git a/Documentation/devicetree/bindings/i2c/i2c-xgene-slimpro.txt b/Documentation/devicetree/bindings/i2c/i2c-xgene-slimpro.txt
> new file mode 100644
> index 0000000..1a79d53
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/i2c/i2c-xgene-slimpro.txt
> @@ -0,0 +1,20 @@
> +APM X-Gene SLIMpro Mailbox I2C Driver
> +
> +This is a I2C driver that access the I2C bus through the mailbox mechanism.
> +There is documentation of the mailbox driver in the
> +Documentation/devicetree/binding/mailbox/xgene-slimpro-mbox.txt
> +
> +Required properties :
> +
> + - compatible : should be "apm,xgene-slimpro-i2c"
> + - mbox : ptr to the mailbox dts node, use the name of the mailbox as the
> +	  first parameter. The second parameter is the channel number.
> +	  The APM X-Gene SLIMpro mailbox has 8 channels.
> + - mbox-names : the name of the mailbox channel.

The current form of the mailbox interface no longer uses mbox-names, so
just drop that. In the old form, the binding would have been incomplete
because you don't list the required name.

	Arnd
