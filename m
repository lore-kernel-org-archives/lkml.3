Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753765Ab3KGT6C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 14:58:02 -0500
Received: from mail-ob0-f169.google.com ([209.85.214.169]:54427 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637Ab3KGT56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 14:57:58 -0500
MIME-Version: 1.0
In-Reply-To: <20131101130835.GC6734@katana>
References: <1381960909-1735-1-git-send-email-tim.kryger@linaro.org>
	<1381960909-1735-3-git-send-email-tim.kryger@linaro.org>
	<20131101130835.GC6734@katana>
Date: Thu, 7 Nov 2013 11:57:57 -0800
Message-ID: <CAAYSxhrrkSvOJpYPz7txVsot1you3fFzkXJ6fqaS4OgRM0Z2gA@mail.gmail.com>
Subject: Re: [RESEND PATCH 2/4] i2c: i2c-bcm-kona: Add support for high-speed mode
From: Tim Kryger <tim.kryger@linaro.org>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Christian Daudt <bcm@fixthebug.org>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Grant Likely <grant.likely@linaro.org>,
        Device Tree List <devicetree@vger.kernel.org>,
        linux-doc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-i2c@vger.kernel.org,
        ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 1, 2013 at 6:08 AM, Wolfram Sang <wsa@the-dreams.de> wrote:
> On Wed, Oct 16, 2013 at 03:01:47PM -0700, Tim Kryger wrote:
>> Add support for I2C high-speed mode (3.4 MHz).
>>
>> Signed-off-by: Tim Kryger <tim.kryger@linaro.org>
>> Reviewed-by: Matt Porter <matt.porter@linaro.org>
>> Reviewed-by: Markus Mayer <markus.mayer@linaro.org>
>
> Mostly good as well:
>
>> +enum hs_bus_speed_index {
>> +     BCM_SPD_3P4MHZ = 0,
>> +};
>
> I just realized that you should update both patches to add the supported
> bus speeds to the binding documentation.

While the bus speed property is really a configuration parameter (and
not a true description of of the hardware) it seems improper to put
driver specific details into the binding document.

Please let me know how you would like me to proceed.

I should mention that I plan to break out the binding into its own
patch as this seems to be the latest best practice just in case that
influences your decision.

Thanks,
Tim Kryger
