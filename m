Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752148Ab3CKNjI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 09:39:08 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:59370 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751468Ab3CKNjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 09:39:07 -0400
Message-ID: <1363009144.3137.72.camel@x61.thuisdomein>
Subject: Re: [PATCH] ARM: imx: fix typo "DEBUG_IMX50_IMX53_UART"
From: Paul Bolle <pebolle@tiscali.nl>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Russell King <linux@arm.linux.org.uk>, Shawn Guo <shawn.guo@linaro.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Date: Mon, 11 Mar 2013 14:39:04 +0100
In-Reply-To: <513DDD59.6000903@cogentembedded.com>
References: <1363007760.3137.69.camel@x61.thuisdomein>
	 <513DDD59.6000903@cogentembedded.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Mar 2013 13:39:04.0864 (UTC) FILETIME=[CC4BE200:01CE1E5D]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-03-11 at 17:34 +0400, Sergei Shtylyov wrote:
> On 11-03-2013 17:16, Paul Bolle wrote:
> > 1) Typo was added in commit f8c95fe6d9adad72fc7bce90f4ab68d119f50c5b
> > ("ARM: imx: support DEBUG_LL uart port selection for all i.MX SoCs").
> > Looking at that patch and at the tree makes clear that DEBUG_IMX53_UART
> > was intended here.
> 
>     Should probably be in the changelog instead.

I feared being to verbose. But putting it in the commit explanation is
fine with me. I'll try to send an updated patch later this day.


Paul Bolle


