Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738Ab3IVCbL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 22:31:11 -0400
Received: from mail.active-venture.com ([67.228.131.205]:64381 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570Ab3IVCbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 22:31:08 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <523E5668.2000201@roeck-us.net>
Date: Sat, 21 Sep 2013 19:31:04 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Soren Brinkmann <soren.brinkmann@xilinx.com>
CC: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Mike Turquette <mturquette@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Joe Perches <joe@perches.com>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Hyun Kwon <hyunk@xilinx.com>
Subject: Re: [PATCH v5] clk: si570: Add a driver for SI570 oscillators
References: <1379806839-13762-1-git-send-email-soren.brinkmann@xilinx.com>
In-Reply-To: <1379806839-13762-1-git-send-email-soren.brinkmann@xilinx.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/21/2013 04:40 PM, Soren Brinkmann wrote:
> Add a driver for SILabs 570, 571, 598, 599 programmable oscillators.
> The devices generate low-jitter clock signals and are reprogrammable via
> an I2C interface.
>
> Cc: Guenter Roeck <linux@roeck-us.net>
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>

Looks good to me. Thanks a lot for picking this up.

Reviewed-by: Guenter Roeck <linux@roeck-us.net>

Guenter

