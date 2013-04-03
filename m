Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761463Ab3DCVZQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 17:25:16 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:60643 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760497Ab3DCVZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 17:25:15 -0400
Message-ID: <515C9E38.9060603@wwwdotorg.org>
Date: Wed, 03 Apr 2013 15:25:12 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Tony Prisk <linux@prisktech.co.nz>
CC: linus.walleij@linaro.org, robherring2@gmail.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        vt8500-wm8505-linux-kernel@googlegroups.com
Subject: Re: [PATCHv5 4/7] pinctrl: gpio: vt8500: Add pincontrol driver for
 arch-vt8500
References: <1364970291-17721-1-git-send-email-linux@prisktech.co.nz> <1364970291-17721-5-git-send-email-linux@prisktech.co.nz>
In-Reply-To: <1364970291-17721-5-git-send-email-linux@prisktech.co.nz>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2013 12:24 AM, Tony Prisk wrote:
> This patch adds support for the GPIO/pinmux controller found on the VIA
> VT8500 and Wondermedia WM8xxx-series SoCs.
> 
> Each pin within the controller is capable of operating as a GPIO or as
> an alternate function. The pins are numbered according to their control
> bank/bit so that if new pins are added, the existing numbering is maintained.
> 
> All currently supported SoCs are included: VT8500, WM8505, WM8650, WM8750 and
> WM8850.
> 
> Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
> Reviewed-by: Stephen Warren <swarren@nvidia.com>

At a quick glance, the alloc/free stuff looks good in this patch, so I
re-affirm the reviewed-by above.
