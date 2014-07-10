Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432AbaGJPvX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 11:51:23 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:52513 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbaGJPvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 11:51:21 -0400
MIME-Version: 1.0
In-Reply-To: <20140710141155.GA24310@redhat.com>
References: <alpine.LRH.2.00.1407071101060.3492@lnfm1.sai.msu.ru>
 <20140709212910.GB26562@kroah.com> <alpine.LRH.2.00.1407101045510.25305@lnfm1.sai.msu.ru>
 <20140710141155.GA24310@redhat.com>
From: "Matwey V. Kornilov" <matwey@sai.msu.ru>
Date: Thu, 10 Jul 2014 19:50:58 +0400
X-Google-Sender-Auth: aGozqrEhMEXPGmkQwGzXZ_p8yG0
Message-ID: <CAJs94EabQGisuySLvDVnDY7Bk95RpNPaV8GsfKqGDexGeb_nVA@mail.gmail.com>
Subject: Re: [PATCHv3 2/2] Add force_epp module option for parport_pc.
To: Dave Jones <davej@redhat.com>, "Matwey V. Kornilov" <matwey@sai.msu.ru>,
        Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        linux-parport@lists.infradead.org,
        Heiko Andreas Sommer <hsommer@eso.org>,
        "Matwey V. Kornilov" <matwey.kornilov@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-07-10 18:11 GMT+04:00 Dave Jones <davej@redhat.com>:
> On Thu, Jul 10, 2014 at 11:56:15AM +0400, Matwey V. Kornilov wrote:
>
>  > Initial check had been introduced in 1999 [1], however I am failed to find
>  > any proves, because davej/history.git is missed.
>
> https://archive.org/details/git-history-of-linux

Thank you, Dave.

This was introduced by cecd99566ac6aba844ff296e461f88131013da94 (2.3.10).
In lkml archives I've found that this code is probably belongs to
David Campbell, whose email has been dropped as bounced. So, I don't
have any idea whether we can contact him.
