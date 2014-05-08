Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845AbaEHNKy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 09:10:54 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:62498 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337AbaEHNKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 09:10:52 -0400
Message-ID: <536B826B.7010908@cogentembedded.com>
Date: Thu, 08 May 2014 17:11:07 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>
CC: Emilio Lopez <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>, stern@rowland.harvard.edu,
        kishon@ti.com, hdegoede@redhat.com,
        Boris Brezillon <boris@free-electrons.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        zhuzhenhua@allwinnertech.com, linux-sunxi@googlegroups.com
Subject: Re: [PATCH 5/7] usb: ohci-platform: Enable optional use of reset
 controller
References: <1399434623-20383-1-git-send-email-maxime.ripard@free-electrons.com> <1399434623-20383-6-git-send-email-maxime.ripard@free-electrons.com> <536A5EBF.10309@cogentembedded.com> <20140507220317.GD7047@lukather>
In-Reply-To: <20140507220317.GD7047@lukather>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 05/08/2014 02:03 AM, Maxime Ripard wrote:

>>> The OHCI controllers used in the Allwinner A31 are asserted in reset using a

>>     s/asserted/powered up/?

> No. There's an external reset controller that maintains these devices
> into reset. It's not only a power on thing, it can also be put back
> into reset later in the life of the system.

    However, the expression that "the OHCI controllers are asserted in reset" 
still seems dubious to me...

> Maxime

WBR, Sergei

