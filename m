Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149Ab3CKO5K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 10:57:10 -0400
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:59236 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751919Ab3CKO5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 10:57:08 -0400
Message-ID: <1363013822.3137.82.camel@x61.thuisdomein>
Subject: Re: [PATCH] ARM: imx: fix typo "DEBUG_IMX50_IMX53_UART"
From: Paul Bolle <pebolle@tiscali.nl>
To: Fabio Estevam <festevam@gmail.com>
Cc: Shawn Guo <shawn.guo@linaro.org>, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Date: Mon, 11 Mar 2013 15:57:02 +0100
In-Reply-To: <CAOMZO5DFh_H5murFk_qR=v+kA2vu46rEjgU4cjjrO2gKtYA5mQ@mail.gmail.com>
References: <1363007760.3137.69.camel@x61.thuisdomein>
	 <20130311133720.GB25910@S2101-09.ap.freescale.net>
	 <CAOMZO5AhjKV=ja+Agr_pMg4ghB6Vux2ciBnr_M8SQuS4AQ4Bzg@mail.gmail.com>
	 <1363009649.3137.78.camel@x61.thuisdomein>
	 <CAOMZO5DFh_H5murFk_qR=v+kA2vu46rEjgU4cjjrO2gKtYA5mQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Mar 2013 14:57:02.0973 (UTC) FILETIME=[B0AAAAD0:01CE1E68]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-03-11 at 10:50 -0300, Fabio Estevam wrote:
> I missed to remove one entry.

Actually, your patch was fine. DEBUG_IMX50_IMX53_UART returned a bit
later - and by accident - in commit
f8c95fe6d9adad72fc7bce90f4ab68d119f50c5b ("ARM: imx: support DEBUG_LL
uart port selection for all i.MX SoCs").


Paul Bolle

