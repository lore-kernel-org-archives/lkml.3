Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932245Ab3K2QkX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 11:40:23 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:40392 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718Ab3K2QkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 11:40:14 -0500
Message-ID: <5298C36C.8000709@ti.com>
Date: Fri, 29 Nov 2013 11:40:12 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Grygorii Strashko <grygorii.strashko@ti.com>
CC: Linus Walleij <linus.walleij@linaro.org>, <linux-gpio@vger.kernel.org>,
        <nsekhar@ti.com>, <prabhakar.csengg@gmail.com>,
        <linux-kernel@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>
Subject: Re: [RFC v1 6/9] arm: dts: keystone: add GPIO device entry
References: <1385494815-15740-1-git-send-email-grygorii.strashko@ti.com> <1385494815-15740-7-git-send-email-grygorii.strashko@ti.com>
In-Reply-To: <1385494815-15740-7-git-send-email-grygorii.strashko@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 November 2013 02:40 PM, Grygorii Strashko wrote:
> This patch adds Keystone GPIO IP device definitions in DT which supports
> up to 32 GPIO lines and each GPIO line can be configured as separate
> interrupt source (so called "unbanked" IRQ).
> 
> For more information see:
>  http://www.ti.com/lit/ug/sprugv1/sprugv1.pdf
> 
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> ---
>  arch/arm/boot/dts/keystone.dtsi |   45 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 45 insertions(+)
> 
Patch 6/9, 7/9, 8/9 and 9/9 needs to be in
a separate series. They all good to me and I
will take them once the GPIO driver re-use gets
sorted out.

Regards,
Santosh

