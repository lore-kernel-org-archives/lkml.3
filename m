Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934126Ab3JPLfd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 07:35:33 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:53461 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760492Ab3JPLfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 07:35:32 -0400
MIME-Version: 1.0
In-Reply-To: <525C3B65.30501@gmail.com>
References: <1381706847-32762-1-git-send-email-roel.kluin@gmail.com>
	<CACRpkdb8ibOm61D_iGkOkbas1475n4k5jptnRH7VFk=9+pipHQ@mail.gmail.com>
	<20131014091230.65047d00@skate>
	<525C3B65.30501@gmail.com>
Date: Wed, 16 Oct 2013 13:35:31 +0200
Message-ID: <CACRpkdbfz=SGZUt8U=u_gMmiRoCmXDv=nfR47jjzeK=wBcRxbQ@mail.gmail.com>
Subject: Re: [PATCH] unset twsi option3 for gconfig as well
From: Linus Walleij <linus.walleij@linaro.org>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Roel Kluin <roel.kluin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 14, 2013 at 8:43 PM, Sebastian Hesselbarth
<sebastian.hesselbarth@gmail.com> wrote:

> @Linus:
> I guess the typo is there from the beginning. You know a good way to
> determine how far it should go back to -stable?

I just add CC: stable and the stable maintainers tend to figure
this out.

> Please apply with following commit msg (or request a proper v2):
>
> """
> This fixes a typo which left twsi config3 option enabled.
> """
>
> and
>
> Acked-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>

OK patch applied and marked for stable.

Yours,
Linus Walleij
