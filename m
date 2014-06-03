Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482AbaFCL1b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 07:27:31 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:61794 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189AbaFCL1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 07:27:30 -0400
MIME-Version: 1.0
In-Reply-To: <10455941.RzodM59Z3O@wuerfel>
References: <10455941.RzodM59Z3O@wuerfel>
Date: Tue, 3 Jun 2014 16:57:28 +0530
Message-ID: <CAK5sBcH8YH1+i0yBUHLqiYWAmOV3v5Dpoavxo-ZOGA8oX0OcwQ@mail.gmail.com>
Subject: Re: [PATCH] serial: samsung: fix typo in debug code
From: Sachin Kamat <spk.linux@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, Joe Perches <joe@perches.com>,
        Doug Anderson <dianders@chromium.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Tue, Jun 3, 2014 at 3:23 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> commit e4ac92df2791 ("serial: samsung: Neaten dbg uses") introduced
> a regression in the conversion from vsprintf to vsnprintf.
>
> This fixes the build error by passing the correct variable name.

I submitted a similar patch sometime back.
http://www.spinics.net/lists/linux-serial/msg12843.html

Regards,
Sachin
