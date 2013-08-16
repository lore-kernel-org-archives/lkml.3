Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012Ab3HPKlD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 06:41:03 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:57549 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205Ab3HPKk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 06:40:59 -0400
Message-ID: <520E01B7.3010804@baylibre.com>
Date: Fri, 16 Aug 2013 12:40:55 +0200
From: Benoit Cousson <bcousson@baylibre.com>
Organization: BayLibre
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Marek Belisko <marek@goldelico.com>
CC: rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ian.campbell@citrix.com, linux@arm.linux.org.uk,
        tony@atomide.com, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH] ARM:dts: Add devicetree for gta04 board.
References: <1376599385-1697-1-git-send-email-marek@goldelico.com>
In-Reply-To: <1376599385-1697-1-git-send-email-marek@goldelico.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marek,

On 15/08/2013 22:43, Marek Belisko wrote:
> This adds devicetree for gta04 (Openmoko next generation board) with necessary
> support for mmc, usb, leds and button.
>
> Signed-off-by: Marek Belisko <marek@goldelico.com>
> ---
>
> This is resurrection of patch sent in March https://lkml.org/lkml/2013/1/24/419
> when I got no reply from maintainer. Patch is updated and based on linux-next (20130807)

Thanks for the update. I added a missing space in the subject and fixed 
an indentation issue for the uart2 node.

Applied in my for_3.12/dts branch.

Regards,
Benoit

