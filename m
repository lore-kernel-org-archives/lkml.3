Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755080AbaEGQ01 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 12:26:27 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:43402 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426AbaEGQ00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 12:26:26 -0400
Message-ID: <536A5EBF.10309@cogentembedded.com>
Date: Wed, 07 May 2014 20:26:39 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Emilio Lopez <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>, stern@rowland.harvard.edu,
        kishon@ti.com, hdegoede@redhat.com
CC: Boris Brezillon <boris@free-electrons.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, zhuzhenhua@allwinnertech.com,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH 5/7] usb: ohci-platform: Enable optional use of reset
 controller
References: <1399434623-20383-1-git-send-email-maxime.ripard@free-electrons.com> <1399434623-20383-6-git-send-email-maxime.ripard@free-electrons.com>
In-Reply-To: <1399434623-20383-6-git-send-email-maxime.ripard@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 07-05-2014 7:50, Maxime Ripard wrote:

> The OHCI controllers used in the Allwinner A31 are asserted in reset using a

    s/asserted/powered up/?

> global reset controller.

> Add optional support for such a controller in the OHCI platform driver.

> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> ---
>   Documentation/devicetree/bindings/usb/usb-ohci.txt |  1 +
>   drivers/usb/host/ohci-platform.c                   | 25 +++++++++++++++++++++-
>   2 files changed, 25 insertions(+), 1 deletion(-)

WBR, Sergei

