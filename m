Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934920Ab3E2BcM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 21:32:12 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:25449 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934480Ab3E2BcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 21:32:10 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-f3-51a55a980b50
From: Jingoo Han <jg1.han@samsung.com>
To: "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Florian Tobias Schandinat'" <FlorianSchandinat@gmx.de>
Cc: "'Olof Johansson'" <olof@lixom.net>,
        "'Jean-Christophe PLAGNIOL-VILLARD'" <plagnioj@jcrosoft.com>,
        linux-fbdev@vger.kernel.org,
        "'Linus Torvalds'" <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        "'Tomi Valkeinen'" <tomi.valkeinen@ti.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        Jingoo Han <jg1.han@samsung.com>
References: <20130524153835.GF15839@game.jcrosoft.org>
 <201305242056.42482.arnd@arndb.de> <51A29DB9.7030505@gmx.de>
 <201305282319.30311.arnd@arndb.de>
In-reply-to: <201305282319.30311.arnd@arndb.de>
Subject: Re: [RFC] Add co-maintainer for fbdev
Date: Wed, 29 May 2013 10:32:08 +0900
Message-id: <002301ce5c0c$5552b650$fff822f0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQIw7dIdKUx0c9ifuu+b/72kcIXzpwLp3dluAhpEeOkBfDhlYJgiOChA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPIsWRmVeSWpSXmKPExsVy+t8zY90ZUUsDDQ5tUbCYs34Nm8XfScfY
	LTpnXmO0uLzwEqvFib4PrBaXd81hszh1/TObxbqHL5gs1s+/xWbxqO8tuwOXx+9fkxg9PnyM
	83h14Q6Lx4kZv1k8rpxoYvXo27KK0eP4je1MHp83yQVwRHHZpKTmZJalFunbJXBlzGk/y1iw
	jLeieclr5gbGbq4uRg4OCQETibt/A7sYOYFMMYkL99azgdhCAssYJW5P84WIm0hM3TCbqYuR
	Cyi+iFFi1rF37BBFvxglfnaagNhsAmoSX74cBouLCMRKnD92ngWkgVngPJNE3+dtbBDdsxgl
	XhxZzQxSxSmgL9Hw+DSYLSygJ3H3y2+w1SwCqhJzvq1mArF5BSwl1rz8zQJhC0r8mHwPzGYW
	0JJYv/M4E4QtL7F5zVtmiFMVJHacfc0IcYWbxKVXn9ggakQk9r14xwhyhITATA6Jlhn9jBDL
	BCS+TT7EAgkKWYlNB6DmSEocXHGDZQLQs0hWz0KyehaS1bOQrFjAyLKKUTS1ILmgOCm9yESv
	ODG3uDQvXS85P3cTIyTyJ+xgvHfA+hBjMtD6icxSosn5wMSRVxJvaGxmZGFqYmpsZG5pRpqw
	kjiveot1oJBAemJJanZqakFqUXxRaU5q8SFGJg5OqQZGoSOntwae2h77LThjaqjDX+bs+h9l
	ExxuiGYpmfT8WL0qcHKJT+GJA+7squtmOq14ktVvsvVXF8NEUf2o1c4TkhdYG+V9eHA86va0
	y4Y3p3d0O7LvW7DxV1CwUXS1Q+6R8jVvgxbsuXR/8qdirq1XeluWnO/eeWBNtfb8ibdaNi8+
	uSwk3/HKKSWW4oxEQy3mouJEAK4hifYSAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHKsWRmVeSWpSXmKPExsVy+t9jAd0ZUUsDDVbdl7aYs34Nm8XfScfY
	LTpnXmO0uLzwEqvFib4PrBaXd81hszh1/TObxbqHL5gs1s+/xWbxqO8tuwOXx+9fkxg9PnyM
	83h14Q6Lx4kZv1k8rpxoYvXo27KK0eP4je1MHp83yQVwRDUw2mSkJqakFimk5iXnp2Tmpdsq
	eQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAHamkUJaYUwoUCkgsLlbSt8M0ITTETdcC
	pjFC1zckCK7HyAANJKxjzJjTfpaxYBlvRfOS18wNjN1cXYycHBICJhJTN8xmgrDFJC7cW8/W
	xcjFISSwiFFi1rF37CAJIYFfjBI/O01AbDYBNYkvXw6DxUUEYiXOHzvPAtLALHCeSaLv8zao
	7lmMEi+OrGYGqeIU0JdoeHwazBYW0JO4++U3G4jNIqAqMefbarDVvAKWEmte/maBsAUlfky+
	B2YzC2hJrN95nAnClpfYvOYtM8SpChI7zr5mhLjCTeLSq09sEDUiEvtevGOcwCg0C8moWUhG
	zUIyahaSlgWMLKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLzczcxglPLM6kdjCsbLA4xCnAwKvHw
	MvxaEijEmlhWXJl7iFGCg1lJhDdVcGmgEG9KYmVValF+fFFpTmrxIcZkoE8nMkuJJucD015e
	SbyhsYmZkaWRmYWRibk5acJK4rwHWq0DhQTSE0tSs1NTC1KLYLYwcXBKNTBWP50083nl201L
	H123bNhmzTotqHv/A1VZGTfncNvvZ6amzt2i2LTrpziHdFHCk8dihmtD81XmLzom9ezqF962
	Sa8ffHhukpn4PH7xtghDi0zOV+sze6XvSJ1Rszw1MX1N/B5Dhwmxs5/0neIwP3S022d+mnqK
	UP6iD1luhvNiLvwoWrKPa9kXJZbijERDLeai4kQAcb7U93EDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, May 29, 2013 6:20 AM, Arnd Bergmann wrote:
> On Monday 27 May 2013, Florian Tobias Schandinat wrote:
> > >> On Fri, May 24, 2013 at 8:38 AM, Jean-Christophe PLAGNIOL-VILLARD
> > >> <plagnioj@jcrosoft.com> wrote:
> > >>> Hi Florian,
> > >>>
> > >>>         As you seems very busy I'd like to propose the help you to handle the
> > >>>         fbdev subsystem to easier the rich of the fbdev patch to Linus
> > >>>
> > >>>         As I'm working on fbdev on at91 and others and already Co-Maintain the
> > >>>         at91 mach on ARM
> > >>>
> > >>>         And if you are not willing to continue I could take over
> >
> > Yeah, it would be great if you could help, at the moment I get barely
> > any sleep, let alone that I could keep up with the majority of mail I
> > get. I'll let you decide whether you want to be sole maintainer or not.
> 
> For any bigger subsystems, it's good practice to have two maintainers,
> even if one of them does all the work. I think it makes sense to have
> Jean-Christophe as the primary maintainer and owner of the git tree,
> but it may also be good to have you or Tomi listed as a second maintainer
> for times when Jean-Christophe isn't available.

Hi Arnd,

I agree with Arnd's opinion.
It looks good to have Florian or Tomi listed as a second maintainer.


Best regards,
Jingoo Han

> 
> I don't know how many patches you'd expect per release, maybe just one
> person is enough after all.
> 
> 	Arnd
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fbdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

