Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756463Ab3ANQKF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 11:10:05 -0500
Received: from mail-la0-f42.google.com ([209.85.215.42]:43119 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757209Ab3ANQKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 11:10:00 -0500
MIME-Version: 1.0
In-Reply-To: <CAFbHwiTafLhK-uJKjUX4_yLC+27OOUnC2JxYM9-3rHZkPx7s5Q@mail.gmail.com>
References: <1357842269-15062-1-git-send-email-dianders@chromium.org>
	<1357923834-31641-1-git-send-email-dianders@chromium.org>
	<1357923834-31641-5-git-send-email-dianders@chromium.org>
	<CAFbHwiTafLhK-uJKjUX4_yLC+27OOUnC2JxYM9-3rHZkPx7s5Q@mail.gmail.com>
Date: Mon, 14 Jan 2013 08:09:56 -0800
Message-ID: <CAD=FV=XEfydu-0oD-Vc_uwqt6qRU9Fs9ROgta3FugSEmPp7nFA@mail.gmail.com>
Subject: Re: [PATCH v4 5/5] mmc: dw_mmc: Remove DW_MCI_QUIRK_NO_WRITE_PROTECT
From: Doug Anderson <dianders@chromium.org>
To: Will Newton <will.newton@gmail.com>
Cc: linux-mmc@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, Will Newton <will.newton@imgtec.com>,
        Chris Ball <cjb@laptop.org>, Jaehoon Chung <jh80.chung@samsung.com>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Will,

On Mon, Jan 14, 2013 at 2:47 AM, Will Newton <will.newton@gmail.com> wrote:
> These changes look ok to me. I don't know if patch 4 made it to the
> list, I only got a copy via the cc and the only archive I can find of
> linux-mmc (gmane) seems to be missing a lot of messages besides this
> one.

It seems to have made it onto patchwork, in any case.  Here's the link:
    https://patchwork.kernel.org/patch/1966771/

The whole bundle of all 5 patches at v4 is here:
    http://patchwork.kernel.org/bundle/dianders/mmc_wp/


> So for the dw_mmc parts:
>
> Acked-by: Will Newton <will.newton@imgtec.com>

Thank you for your review and your ack.  :)

-Doug
