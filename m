Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757140Ab3E0ITQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 04:19:16 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:34348 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757107Ab3E0ITM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 04:19:12 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-87-51a316fe8229
From: Jingoo Han <jg1.han@samsung.com>
To: "'Tomi Valkeinen'" <tomi.valkeinen@ti.com>,
        "'Jean-Christophe PLAGNIOL-VILLARD'" <plagnioj@jcrosoft.com>
Cc: "'Florian Tobias Schandinat'" <FlorianSchandinat@gmx.de>,
        "'Arnd Bergmann'" <arnd@arndb.de>, "'Olof Johansson'" <olof@lixom.net>,
        linux-fbdev@vger.kernel.org,
        "'Linus Torvalds'" <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>
References: <20130524153835.GF15839@game.jcrosoft.org>
 <CAOesGMj26_=6eQk+=0MPCoobymqrHPwwtiUnv63hz0a9Ou_VMw@mail.gmail.com>
 <201305242056.42482.arnd@arndb.de> <51A29DB9.7030505@gmx.de>
 <51A31013.9010701@ti.com>
In-reply-to: <51A31013.9010701@ti.com>
Subject: Re: [RFC] Add co-maintainer for fbdev
Date: Mon, 27 May 2013 17:19:10 +0900
Message-id: <001501ce5ab2$dd2e9860$978bc920$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQIw7dIdKUx0c9ifuu+b/72kcIXzpwH2hDjSAund2W4CGkR46QEx3JSlmBIkN0A=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpileLIzCtJLcpLzFFi42I5/e+Zge4/scWBBrc2S1vMWb+GzeLvpGPs
	Fp0zrzFaXF54idXiRN8HVovLu+awWZy6/pnNYt3DF0wW6+ffYrN41PeW3YHL4/evSYweHz7G
	eby6cIfF48SM3yweV040sXr0bVnF6HH8xnYmj8+b5AI4orhsUlJzMstSi/TtErgy9n98yFRw
	lati4eoJLA2M/9i7GDk5JARMJI4dX8IIYYtJXLi3nq2LkYtDSGAZo8SGPQdZYYq2dK1ihUgs
	YpToeLKECcL5xSjx8eVrFpAqNgE1iS9fDoONFRHIkthyaQoLSBGzwAMmiQ9Hf0PNvcEoMefQ
	aiaQKk6gju3LloHZwgJ6Ene/gBRxcrAIqEo0TD0AtptXwFLi+cQPTBC2oMSPyffAtjELaEms
	33mcCcKWl9i85i0zxK0KEjvOvmaEuMJPon36YVaIGhGJfS/eMYIcISEwlUOi+/8GFohlAhLf
	Jh8CsjmAErISmw5AzZGUOLjiBssERolZSFbPQrJ6FpLVs5CsWMDIsopRNLUguaA4Kb3IRK84
	Mbe4NC9dLzk/dxMjJP4n7GC8d8D6EGMy0PqJzFKiyfnA9JFXEm9obGZkYWpiamxkbmlGmrCS
	OK96i3WgkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBsaiK6X/nnyr9z8ivaVO4sW5l5Y2Acv3
	ORxyz1G8Hb3zyTs95aNbg7ZVX3n+bFmzxbtzf6eLSvOwlCoY6jce37XviHB0ncRrdZVYaf+l
	v+fpyzBUyvB76no1JGXGH+g8m37p+tUv3bf8D/b11cudfVvqvKI+jcX0/wU9cZl4USmuBN99
	xz27PJRYijMSDbWYi4oTAeW5XQYVAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPKsWRmVeSWpSXmKPExsVy+t9jAd1/YosDDdZOFrOYs34Nm8XfScfY
	LTpnXmO0uLzwEqvFib4PrBaXd81hszh1/TObxbqHL5gs1s+/xWbxqO8tuwOXx+9fkxg9PnyM
	83h14Q6Lx4kZv1k8rpxoYvXo27KK0eP4je1MHp83yQVwRDUw2mSkJqakFimk5iXnp2Tmpdsq
	eQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAHamkUJaYUwoUCkgsLlbSt8M0ITTETdcC
	pjFC1zckCK7HyAANJKxjzNj/8SFTwVWuioWrJ7A0MP5j72Lk5JAQMJHY0rWKFcIWk7hwbz1b
	FyMXh5DAIkaJjidLmCCcX4wSH1++ZgGpYhNQk/jy5TBYt4hAlsSWS1NYQIqYBR4wSXw4+huq
	/QajxJxDq5lAqjiBOrYvWwZmCwvoSdz9AlLEycEioCrRMPUA2G5eAUuJ5xM/MEHYghI/Jt8D
	28YsoCWxfudxJghbXmLzmrfMELcqSOw4+5oR4go/ifbph1khakQk9r14xziBUWgWklGzkIya
	hWTULCQtCxhZVjGKphYkFxQnpeca6RUn5haX5qXrJefnbmIEJ5dn0jsYVzVYHGIU4GBU4uFd
	MGNRoBBrYllxZe4hRgkOZiUR3oRooBBvSmJlVWpRfnxRaU5q8SHGZKBPJzJLiSbnAxNfXkm8
	obGJmZGlkZmFkYm5OWnCSuK8B1utA4UE0hNLUrNTUwtSi2C2MHFwSgHTGQvzniOKss6ie7cw
	54lxCthnODg5rV1X1P9Xl8m66crdwkdCU1se5yrFZE9wnfWwMO2eSwCv0tGqr6rTJmmm/r/K
	soNhrmyAGc9ssVw13miru8oHPA5uauF6sf1HS0yxXrH600XGlRblb/q0ihc8qphYeWum9ZfS
	j3bL/sVPq+Q9tVO31kyJpTgj0VCLuag4EQAFT6cYcgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, May 27, 2013 4:50 PM, Jean-Christophe PLAGNIOL-VILLARD wrote:
> 
> Hi Jean-Christophe,
> 
> >>> On Fri, May 24, 2013 at 8:38 AM, Jean-Christophe PLAGNIOL-VILLARD
> >>> <plagnioj@jcrosoft.com> wrote:
> >>>> Hi Florian,
> >>>>
> >>>>         As you seems very busy I'd like to propose the help you to handle the
> >>>>         fbdev subsystem to easier the rich of the fbdev patch to Linus
> >>>>
> >>>>         As I'm working on fbdev on at91 and others and already Co-Maintain the
> >>>>         at91 mach on ARM
> >>>>
> >>>>         And if you are not willing to continue I could take over
> 
> I've been collecting fbdev patches for the latest merge windows, so that
> Linus doesn't get tons of small separate pull requests. But I haven't
> been very proactive with that, and I don't think I have time to really
> maintain fbdev.

Hi Tomi,

I really thank you for your previous efforts.
Actually, I thought that you're a good fit for fbdev.

> 
> So I'd also welcome somebody stepping up and taking taking on the
> maintainership of fbdev.

Hi Jean-Christophe PLAGNIOL-VILLARD,

I agree with Tomi's opinion.
If you take the maintainership of fbdev, it will be very helpful.


Best regards,
Jingoo Han

> 
>  Tomi
> 
> Ps. I already have a few patches for 3.10 and for 3.11. I'll send them
> to you.
> 


