Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357Ab3GUBsV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 21:48:21 -0400
Received: from smtp102.biz.mail.bf1.yahoo.com ([98.139.221.61]:43436 "HELO
	smtp102.biz.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754731Ab3GUBsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 21:48:17 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: ciGj1TYVM1mOYGwpWB7Edz.ML_ijF6uoAZQebxOHyA8gH8V
 Y1JPp8mHUkbZtdsBb8c5Xn8Nz.PkpXc5yikqKUAQvJ2DanzmALbglmRMPESb
 f7gGBdDX7_lGsNEkZcXvgAVi1ElCNu5XAgJEGEknUBgzSX2ag2hEIbGfe8Js
 JpcWb3JN1aq0s448mboYJQhHXjRX11TPhDWPO7BkEXhXZcUt8Kz.hX1NL.FQ
 5r2lCJqkdeL.iTsi7naXy_lxhASDQA1UMxQaK.BNr2SrdvmTYbvRpks.Hu6T
 AO_yi5W.eJuMzm3HX2sOkAD2A0_e2qD8Qnmj_w4s8iptCdBe8sHP9NrDmvp0
 7s.yqA65uKkTFJNZ3RuMCTFDmIHYfzu_NfoQGeFPDf_ODAT_5tXIYQ8ikaMk
 HHCs1w7mYqXkbBBl3FZpNDDPgpu14_dpz3QolNyFfBmI0otw.YRcqz8HSkRi
 ljiVrm2W9hM0yjztu20w9wKbddeeiSW2lYVsdFkP2HRQVVQF2NAaZPY9lku1
 VVO6gYXTjhgq8
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-Rocket-Received: from [192.168.0.103] (casey@24.6.250.25 with )
        by smtp102.biz.mail.bf1.yahoo.com with SMTP; 20 Jul 2013 18:41:35 -0700 PDT
Message-ID: <51EB3C4F.8070805@schaufler-ca.com>
Date: Sat, 20 Jul 2013 18:41:35 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Phil Carmody <phil.carmody@partner.samsung.com>
CC: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        jarkko.sakkinen@iki.fi, Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH] smack: fix magic value
References: <1373457073-2571-1-git-send-email-phil.carmody@partner.samsung.com>
In-Reply-To: <1373457073-2571-1-git-send-email-phil.carmody@partner.samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/10/2013 4:51 AM, Phil Carmody wrote:
> 5d is ']', 'M' is 4d.

And spelling was never my strong suit. I don't know of anyone
who depends on this value, but in case someone does the correct
fix is to change the comment, not the constant.

>
> Signed-off-by: Phil Carmody <phil.carmody@partner.samsung.com>
> ---
>  include/uapi/linux/magic.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/include/uapi/linux/magic.h b/include/uapi/linux/magic.h
> index 2944278..5c1d878 100644
> --- a/include/uapi/linux/magic.h
> +++ b/include/uapi/linux/magic.h
> @@ -11,7 +11,7 @@
>  #define DEBUGFS_MAGIC          0x64626720
>  #define SECURITYFS_MAGIC	0x73636673
>  #define SELINUX_MAGIC		0xf97cff8c
> -#define SMACK_MAGIC		0x43415d53	/* "SMAC" */
> +#define SMACK_MAGIC		0x43414d53	/* "SMAC" */
>  #define RAMFS_MAGIC		0x858458f6	/* some random number */
>  #define TMPFS_MAGIC		0x01021994
>  #define HUGETLBFS_MAGIC 	0x958458f6	/* some random number */

