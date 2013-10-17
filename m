Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761987Ab3JQB6B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 21:58:01 -0400
Received: from mail.active-venture.com ([67.228.131.205]:54570 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761322Ab3JQB6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 21:58:00 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <525F4421.3090404@roeck-us.net>
Date: Wed, 16 Oct 2013 18:57:53 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: alsa-devel@alsa-project.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Timur Tabi <timur@tabi.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH] ASoC: fsl_ssi: Fix irq_of_parse_and_map() return value
 check
References: <1380773722-1295-1-git-send-email-linux@roeck-us.net> <20131003155816.GU27287@sirena.org.uk>
In-Reply-To: <20131003155816.GU27287@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2013 08:58 AM, Mark Brown wrote:
> On Wed, Oct 02, 2013 at 09:15:22PM -0700, Guenter Roeck wrote:
>> irq_of_parse_and_map() returns 0 on error, not NO_IRQ.
>
> Applied, thanks.
>
Hi Mark,

do you plan to send this patch upstream anytime soon ?

It fixes an xtensa build problem, so it would be great if it could find its way into 3.13.

Thanks,
Guenter

