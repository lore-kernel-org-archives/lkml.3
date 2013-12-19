Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238Ab3LSR3P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 12:29:15 -0500
Received: from 16.mo3.mail-out.ovh.net ([188.165.56.217]:36471 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754111Ab3LSR3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 12:29:11 -0500
Message-ID: <52B32A70.1080700@overkiz.com>
Date: Thu, 19 Dec 2013 18:18:40 +0100
From: boris brezillon <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: balbi@ti.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Rob Landley <rob@landley.net>, Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Jiri Prchal <jiri.prchal@aksignal.cz>,
        Ben Gamari <bgamari.foss@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [RFC PATCH] gpio: add GPIO hogging mechanism
References: <1387463671-1164-1-git-send-email-b.brezillon@overkiz.com> <1387463671-1164-2-git-send-email-b.brezillon@overkiz.com> <20131219164109.GB27409@kroah.com> <20131219164737.GA4536@saruman.home>
In-Reply-To: <20131219164737.GA4536@saruman.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 3064136597336848581
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrtdefucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrtdefucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Felipe,

On 19/12/2013 17:47, Felipe Balbi wrote:
> On Thu, Dec 19, 2013 at 08:41:09AM -0800, Greg Kroah-Hartman wrote:
>> On Thu, Dec 19, 2013 at 03:34:31PM +0100, Boris BREZILLON wrote:
>>> GPIO hogging is a way to request and configure specific GPIO without
>>> explicitly requesting it in the device driver.
>>>
>>> The request and configuration procedure is handled in the core device
>>> driver code before the driver probe function is called.
>>>
>>> It allows specific GPIOs to be configured without any driver specific code.
>>>
>>> Particularly usefull when a external device is connected to a bus and the
>>> bus connections depends on an external switch controlled by a GPIO pin.
> for external switches, you probably need a pinctrl-gpio driver.
>
Do you mean using pinctrl pinconf to configure the PIN as output-high or
output-low ?

This was my first proposal
(see https://www.mail-archive.com/devicetree@vger.kernel.org/msg05829.html).


Best Regards,

Boris
