Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842Ab3H2COm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 22:14:42 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:16089 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752981Ab3H2COk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 22:14:40 -0400
X-AuditID: cbfee68f-b7f656d0000058e3-25-521eae8e48ce
From: Jingoo Han <jg1.han@samsung.com>
To: "'Anton Vorontsov'" <anton@enomsg.org>
Cc: "'Dan Carpenter'" <dan.carpenter@oracle.com>,
        "'David Woodhouse'" <dwmw2@infradead.org>,
        linux-kernel@vger.kernel.org, "'Joe Perches'" <joe@perches.com>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Mark Brown'" <broonie@kernel.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <005c01ce8cfd$82078af0$8616a0d0$@samsung.com>
 <20130809220451.GG12638@lizard.sbx05730.santaca.wayport.net>
 <003401ce96f2$0f53b840$2dfb28c0$@samsung.com> <20130813090039.GA5604@mwanda>
 <20130828015834.GH10506@lizard>
 <002d01cea395$0ef33ec0$2cd9bc40$%han@samsung.com>
 <20130828083630.GF19256@mwanda> <20130829011848.GA16891@teo>
In-reply-to: <20130829011848.GA16891@teo>
Subject: Re: [PATCH 33/35] power: use dev_get_platdata()
Date: Thu, 29 Aug 2013 11:14:37 +0900
Message-id: <002801cea45d$8331b5f0$899521d0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6kVbn/ezdhljAkTiKbsQZWdDkQ9wABrgwQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLIsWRmVeSWpSXmKPExsVy+t8zI92+dXJBBguaBC3mrF/DZnFwq6bF
	1IdP2Cxe/5vOYjFx5WRmi+bF69ksLi+8xGox+/5jFovLu+awOXB6TOj/xOixeYWWx6ZVnWwe
	J2b8ZvHYP3cNu8fHp7dYPL6susbs0bdlFaPH501yAZxRXDYpqTmZZalF+nYJXBlL2uaxFPRw
	VFz5e5GxgXELWxcjJ4eEgInE53VbmSBsMYkL99YDxbk4hASWMUq0tP9nhSmases9M0RiEaPE
	j73d7BDOL0aJp9v2gbWzCahJfPlymB3EFhHQkGhbPYUFxGYWOM4kMeGILkTDHSaJlb+WgxVx
	CmhKrOheCrZCWMBCor27FSzOIqAq8en7LWYQm1fAVuLH4z5GCFtQ4sfke0BDOYCGqktMmZIL
	MV9eYvOat8wgYQmg8KO/uhAnGEkcXTmZFaJERGLfi3eMICdICEzkkJh6CGaVgMS3yYdYIHpl
	JTYdYIZ4WFLi4IobLBMYJWYhWTwLYfEsJItnIdmwgJFlFaNoakFyQXFSepGxXnFibnFpXrpe
	cn7uJkZI1PfvYLx7wPoQYzLQ9onMUqLJ+cCkkVcSb2hsZmRhamJqbGRuaUaasJI4r1qLdaCQ
	QHpiSWp2ampBalF8UWlOavEhRiYOTqkGRjc794ZNE2Vf8iiHaJsHrFz4oc1x8VfLzKt2/EkH
	w8qWZWnH/Re8sULlxpZrige17EK2KwZdWvqOZ5V29YLiGa1HtgVlPrjXMcEsd7bfr6/Lo12L
	TxbpbHuWyrhxfs074Zhen6VdEqdfu31m/GCeVXFX913ylPYriecazp+3SFtb+tVvYcJDZiWW
	4oxEQy3mouJEAI3TowsQAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFKsWRmVeSWpSXmKPExsVy+t9jAd2+dXJBBm1beSzmrF/DZnFwq6bF
	1IdP2Cxe/5vOYjFx5WRmi+bF69ksLi+8xGox+/5jFovLu+awOXB6TOj/xOixeYWWx6ZVnWwe
	J2b8ZvHYP3cNu8fHp7dYPL6susbs0bdlFaPH501yAZxRDYw2GamJKalFCql5yfkpmXnptkre
	wfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUA3KimUJeaUAoUCEouLlfTtME0IDXHTtYBp
	jND1DQmC6zEyQAMJ6xgzlrTNYyno4ai48vciYwPjFrYuRk4OCQETiRm73jND2GISF+6tB4pz
	cQgJLGKU+LG3mx3C+cUo8XTbPiaQKjYBNYkvXw6zg9giAhoSbaunsIDYzALHmSQmHNGFaLjD
	JLHy13KwIk4BTYkV3UtZQWxhAQuJ9u5WsDiLgKrEp++3wFbzCthK/HjcxwhhC0r8mHwPaCgH
	0FB1iSlTciHmy0tsXvOWGSQsARR+9FcX4gQjiaMrJ7NClIhI7HvxjnECo9AsJINmIQyahWTQ
	LCQdCxhZVjGKphYkFxQnpeca6hUn5haX5qXrJefnbmIEp5RnUjsYVzZYHGIU4GBU4uGN+C0b
	JMSaWFZcmXuIUYKDWUmEd0qmXJAQb0piZVVqUX58UWlOavEhxmSgNycyS4km5wPTXV5JvKGx
	iZmRpZGZhZGJuTlpwkrivAdarQOFBNITS1KzU1MLUotgtjBxcEo1MAqvf+ry494SdvWHbq97
	3l4I01OzWPf+E9cuq/RpJuqcLeod8y14jwn3Z+YWLG16E3e5b23m/6zk2Nmq7hF7Yu1t5/Hd
	i/wRPvH+2XVLW3j1Ff6ohJ+I5Jw747/MHe9v3yo+JtdVbGFiS39YZhWvsH772is85wq7v2wq
	28dr2LN/WrLfvz/qk5VYijMSDbWYi4oTAdi9++htAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, August 29, 2013 10:19 AM, Anton Vorontsov wrote:
> On Wed, Aug 28, 2013 at 11:36:30AM +0300, Dan Carpenter wrote:
> > He doesn't want to take the patch.  He's the maintainer so it's his
> > choice.  That's the end of the story.
> 
> Just to clarify: I don't want to take the patch for a reason, not just
> because of my mood today. Once the patch comes in combination with another
> patch (or a plan) that actually makes use of the wrapper function, then
> I'd happily apply/ack it.

Sorry, I cannot understand.
This patch is a just cosmetic change.
I cannot understand why you reject it.

> 
> This is the same story as global checkpatch.pl fixes: they are more harm
> than good, and without the actual use of the dev_get_platdata(), the patch
> falls into "global checkpatch.pl fixes" category.

So, what is the harm of the fix using dev_get_platdata() wrapper function?
What is "the actual use of the dev_get_platdata()"?
Please, give me more detailed description.


Best regards,
Jingoo Han

