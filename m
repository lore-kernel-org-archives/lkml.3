Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239AbaENMas (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 08:30:48 -0400
Received: from mail-qg0-f54.google.com ([209.85.192.54]:51135 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899AbaENMaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 08:30:46 -0400
MIME-Version: 1.0
In-Reply-To: <20140514122357.11052.qmail@ns.horizon.com>
References: <CAPDyKFo9xZ-z6eM0zG2A+=Bwj0EVyGxm=m28Lh9cHPSB+8qq1w@mail.gmail.com>
	<20140514122357.11052.qmail@ns.horizon.com>
Date: Wed, 14 May 2014 14:30:45 +0200
Message-ID: <CAPDyKFqu4ZcJVZH+9-9ett1fAo5T8ff+F+hf-j95cJuRPzGi5A@mail.gmail.com>
Subject: Re: [PATCH 2/3] drivers/mmc/host/mmc_spi.c: Use get/put_unaligned_be32
From: Ulf Hansson <ulf.hansson@linaro.org>
To: George Spelvin <linux@horizon.com>
Cc: arik@wizery.com, david.gnedt@davizone.at, eliad@wizery.com,
        jan.nikitenko@gmail.com,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>,
        linux-wireless@vger.kernel.org, John Linville <linville@tuxdriver.com>,
        luca@coelho.fi, Pavel Machek <pavel@ucw.cz>,
        Tony Lindgren <tony@atomide.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 May 2014 14:23, George Spelvin <linux@horizon.com> wrote:
> Ulf Hansson wrote:
>> Feel free to take this through the wireless tree as well. I assumes
>> it's that same patchset as the other spi related fixes?
>
> I'd like to answer, but I'm not sure which "other spi related fixes"
> you're referring to.  If you mean patches 1 and 3 of this series, then
> obviously.  If you mean something else then probably not.
>
> [PATCH 1/3] lib/crc7: Shift crc7() output left 1 bit
> [PATCH 3/3] drivers/net/wireless/ti/wl*/spi.c: Simplify CRC computation
>

Sorry for being unclear. It's those above I referred to.

Kind regards
Ulf Hansson
