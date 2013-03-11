Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941Ab3CKNuH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 09:50:07 -0400
Received: from mail-vb0-f52.google.com ([209.85.212.52]:50807 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872Ab3CKNuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 09:50:05 -0400
MIME-Version: 1.0
In-Reply-To: <1363009649.3137.78.camel@x61.thuisdomein>
References: <1363007760.3137.69.camel@x61.thuisdomein>
	<20130311133720.GB25910@S2101-09.ap.freescale.net>
	<CAOMZO5AhjKV=ja+Agr_pMg4ghB6Vux2ciBnr_M8SQuS4AQ4Bzg@mail.gmail.com>
	<1363009649.3137.78.camel@x61.thuisdomein>
Date: Mon, 11 Mar 2013 10:50:04 -0300
Message-ID: <CAOMZO5DFh_H5murFk_qR=v+kA2vu46rEjgU4cjjrO2gKtYA5mQ@mail.gmail.com>
Subject: Re: [PATCH] ARM: imx: fix typo "DEBUG_IMX50_IMX53_UART"
From: Fabio Estevam <festevam@gmail.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Shawn Guo <shawn.guo@linaro.org>, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 10:47 AM, Paul Bolle <pebolle@tiscali.nl> wrote:

> That's not correct:
>     $ git grep -n DEBUG_IMX50_IMX53_UART v3.9-rc2
>     v3.9-rc2:arch/arm/Kconfig.debug:495:                                            DEBUG_IMX50_IMX53_UART || \

Yes, you are right. I missed to remove one entry.
