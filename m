Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756514Ab3BQX7c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 18:59:32 -0500
Received: from server19320154104.serverpool.info ([193.201.54.104]:36775 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756266Ab3BQX7b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 18:59:31 -0500
Message-ID: <51216ED8.5040906@hauke-m.de>
Date: Mon, 18 Feb 2013 00:59:20 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Ralf Baechle <ralf@linux-mips.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, John Crispin <blogic@openwrt.org>
Subject: Re: linux-next: build failure after merge of the mips tree
References: <20130218104340.eb5e20da05dffe89ac4da693@canb.auug.org.au>
In-Reply-To: <20130218104340.eb5e20da05dffe89ac4da693@canb.auug.org.au>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 02/18/2013 12:43 AM, Stephen Rothwell wrote:
> Hi Ralf,
> 
> After merging the mips tree, today's linux-next build (x86_64 
> allmodconfig) failed like this:
> 
> drivers/ssb/driver_gpio.c: In function 'ssb_gpio_chipco_to_irq': 
> drivers/ssb/driver_gpio.c:82:3: error: implicit declaration of
> function 'ssb_mips_irq' [-Werror=implicit-function-declaration]
> 
> Caused by commit d630dd4ef20f ("ssb: add gpio_to_irq again").
> 
> I have used the mips tree from next-20130215 for today.
> 
Hi Ralf and blogic,

Could you drop this patch [0] and this one [1].

I saw that they are not any more in blogic tree.

Hauke

[0]: https://patchwork.linux-mips.org/patch/4719/
[1]: https://patchwork.linux-mips.org/patch/4720/
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iQIcBAEBAgAGBQJRIW7SAAoJEIZ0px9YPRMySfMQAII6ZFgh+dDS/gEhxCmZ5EJZ
dmz5AjafHmmqAKuw5j5erKvRzocxaxwLscvEjv6WXD/dGD7DoUkixSkoHD0G5ptE
gba3OL8qqBQGzuqhUsfKCnYS3b7UGYC95G9qS03jcikm46Rl3ufpEnOswkIwyssw
Qd0yVqvsmXDaTz6LljwSYGT6BxLo63QmoaxH64yCXwYtOh+vGanif8U+QZcg61Hm
jL1CRlbzjJg5VrtTOak9SVsRFRp4TOvJe7TI5P/Nm20mkt6q+1sWcoOXa1egG0k7
68Y2hTzlERTK6LCpmHRZcQxXPbMl/KP03+mgtqcN5xQtkGq4NfcnfG0HIANo9fpf
BlnCX//gDaLRVcwlQnAShVYRcLd+tjb6l+2ObYLShJVFPdD5YJ3sTiySKW7xVW04
iFlzxDWKYA2NILHldHHa+MX7r86IBPLrZhG+IqgdjLcw4zQZiGn2heVSQipzmPGm
eBWqJuSUtVYNrEFVd/+CcqHo5jvmqmybh7+DLi6fVBvNb1vh9ApmltVuD37T00CB
d3bOF5VEFQR+zoNloxriI84SCZPRu/in8f/Bqy9x+iGnkgW+FxnJnDi4kEaerNB7
jjZow64JwE5f/pYHle/ffLUvsCRLV7GpvJ33n4OxFQyVMYHrPEdbF2r+YkytA5zJ
KzZDEk6WfzVItcPcjSTg
=EwXd
-----END PGP SIGNATURE-----
