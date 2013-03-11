Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752309Ab3CKNlI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 09:41:08 -0400
Received: from mail-ve0-f176.google.com ([209.85.128.176]:56052 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130Ab3CKNlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 09:41:06 -0400
MIME-Version: 1.0
In-Reply-To: <20130311133720.GB25910@S2101-09.ap.freescale.net>
References: <1363007760.3137.69.camel@x61.thuisdomein>
	<20130311133720.GB25910@S2101-09.ap.freescale.net>
Date: Mon, 11 Mar 2013 10:41:05 -0300
Message-ID: <CAOMZO5AhjKV=ja+Agr_pMg4ghB6Vux2ciBnr_M8SQuS4AQ4Bzg@mail.gmail.com>
Subject: Re: [PATCH] ARM: imx: fix typo "DEBUG_IMX50_IMX53_UART"
From: Fabio Estevam <festevam@gmail.com>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Paul Bolle <pebolle@tiscali.nl>, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 10:37 AM, Shawn Guo <shawn.guo@linaro.org> wrote:
> Paul,
>
> On Mon, Mar 11, 2013 at 02:16:00PM +0100, Paul Bolle wrote:
>> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
>> ---
>> 0) Tested by grepping the tree.
>>
>> 1) Typo was added in commit f8c95fe6d9adad72fc7bce90f4ab68d119f50c5b
>> ("ARM: imx: support DEBUG_LL uart port selection for all i.MX SoCs").
>> Looking at that patch and at the tree makes clear that DEBUG_IMX53_UART
>> was intended here.
>
> Thanks for the fixing.  Above comment should really be in the commit
> log.  I just applied the patch as below.

Please see my commit:

commit 7356420cd34e40fe27bf26555b0bf3f2849a43dd
Author: Fabio Estevam <fabio.estevam@freescale.com>
Date:   Tue Jan 22 10:40:55 2013 -0200

    ARM: imx: Remove mx508 support

    Only mx508 based board is mach-mx50_rdp and it has been marked as BROKEN
    for several releases.

    mx508 currently lacks clock support.

    In case someone needs to add mx508 support back, then the
recommended approach
    is to use device tree.

    Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
    Signed-off-by: Shawn Guo <shawn.guo@linaro.org>

,it does remove the MX50 reference, so this patch is not needed.
