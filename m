Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756607Ab3CDJOf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 04:14:35 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:42039 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756556Ab3CDJOc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 04:14:32 -0500
MIME-Version: 1.0
In-Reply-To: <1362073866-8462-1-git-send-email-pali.rohar@gmail.com>
References: <1362073866-8462-1-git-send-email-pali.rohar@gmail.com>
Date: Mon, 4 Mar 2013 03:14:31 -0600
Message-ID: <CAJ6Av5O9n99t01-+dprqOkC7Nyp8vpBQANWbgZqWiemUy8Q0tQ@mail.gmail.com>
Subject: Re: [PATCH] tidspbridge: Fix compilation
From: Omar Ramirez Luna <omar.ramirez@copitl.com>
To: =?ISO-8859-1?Q?Pali_Roh=E1r?= <pali.rohar@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tony Lindgren <tony@atomide.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Joni Lapilainen <joni.lapilainen@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Feb 28, 2013 at 11:51 AM, Pali Rohár <pali.rohar@gmail.com> wrote:
> Fix includes and use clk_prepare_enable/clk_disable_unprepare
>
> Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> Signed-off-by: Joni Lapilainen <joni.lapilainen@gmail.com>
> ---
>  drivers/staging/tidspbridge/core/dsp-clock.c  |   16 ++++++++--------
>  drivers/staging/tidspbridge/core/tiomap3430.c |    2 ++
>  drivers/staging/tidspbridge/core/tiomap_io.c  |    2 ++
>  drivers/staging/tidspbridge/core/wdt.c        |    8 ++++----
>  4 files changed, 16 insertions(+), 12 deletions(-)

AFAIK, this has been taken care in the past by:

e16a922a staging: tidspbridge: use prepare/unprepare on dsp clocks
fe025085 staging: tidspbridge: Fix build breakage due to splitting CM functions

Would you mind pointing the target for your patches? Perhaps stable?

Cheers,

Omar
