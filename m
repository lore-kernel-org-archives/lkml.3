Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197Ab3EPPiL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 11:38:11 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:59915 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256Ab3EPPiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 11:38:07 -0400
Message-ID: <5194FD48.3010106@free-electrons.com>
Date: Thu, 16 May 2013 17:37:44 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Shawn Guo <shawn.guo@linaro.org>, linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gpio: mxs: Use set and clear capabilities of the gpio
 controller
References: <1367244438-5322-1-git-send-email-maxime.ripard@free-electrons.com> <20130502024443.GE3442@S2101-09.ap.freescale.net>
In-Reply-To: <20130502024443.GE3442@S2101-09.ap.freescale.net>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Le 02/05/2013 04:44, Shawn Guo a écrit :
> On Mon, Apr 29, 2013 at 04:07:18PM +0200, Maxime Ripard wrote:
>> The current driver doesn't use the set and clear registers found on the
>> mxs gpio controller.
>>
>> This leads the generic gpio controller to be using some internal value
>> to avoid looking up the value stored in the registers, making it behave
>> pretty much like a cache.
>>
>> This raises some coherency problem when a gpio is not modified by the
>> gpio controller, while it can easily be fixed by using the set and clear
>> registers.
>>
>> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> 
> Acked-by: Shawn Guo <shawn.guo@linaro.org>

Would you consider merging this patch?

Thanks,
Maxime

-- 
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
