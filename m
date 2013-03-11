Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104Ab3CKNnn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 09:43:43 -0400
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:52311 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751352Ab3CKNnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 09:43:41 -0400
Message-ID: <1363009420.3137.76.camel@x61.thuisdomein>
Subject: Re: [PATCH] ARM: imx: fix typo "DEBUG_IMX50_IMX53_UART"
From: Paul Bolle <pebolle@tiscali.nl>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Mon, 11 Mar 2013 14:43:40 +0100
In-Reply-To: <20130311133720.GB25910@S2101-09.ap.freescale.net>
References: <1363007760.3137.69.camel@x61.thuisdomein>
	 <20130311133720.GB25910@S2101-09.ap.freescale.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Mar 2013 13:43:40.0476 (UTC) FILETIME=[7092EFC0:01CE1E5E]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-03-11 at 21:37 +0800, Shawn Guo wrote:
> On Mon, Mar 11, 2013 at 02:16:00PM +0100, Paul Bolle wrote:
> > 1) Typo was added in commit f8c95fe6d9adad72fc7bce90f4ab68d119f50c5b
> > ("ARM: imx: support DEBUG_LL uart port selection for all i.MX SoCs").
> > Looking at that patch and at the tree makes clear that DEBUG_IMX53_UART
> > was intended here.
> 
> Thanks for the fixing.  Above comment should really be in the commit
> log.  I just applied the patch as below.

Thanks for updating the commit explanation. I guess I'll have to reserve
the "one line commit summary only" style for the really obvious typos.


Paul Bolle

