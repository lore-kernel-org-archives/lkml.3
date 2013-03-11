Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751721Ab3CKNfD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 09:35:03 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:59171 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083Ab3CKNfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 09:35:01 -0400
Message-ID: <513DDD59.6000903@cogentembedded.com>
Date: Mon, 11 Mar 2013 17:34:17 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: Russell King <linux@arm.linux.org.uk>, Shawn Guo <shawn.guo@linaro.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: imx: fix typo "DEBUG_IMX50_IMX53_UART"
References: <1363007760.3137.69.camel@x61.thuisdomein>
In-Reply-To: <1363007760.3137.69.camel@x61.thuisdomein>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 11-03-2013 17:16, Paul Bolle wrote:

> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> 0) Tested by grepping the tree.

> 1) Typo was added in commit f8c95fe6d9adad72fc7bce90f4ab68d119f50c5b
> ("ARM: imx: support DEBUG_LL uart port selection for all i.MX SoCs").
> Looking at that patch and at the tree makes clear that DEBUG_IMX53_UART
> was intended here.

    Should probably be in the changelog instead.

WBR, Sergei

