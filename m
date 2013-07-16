Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758461Ab3GPAOY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 20:14:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46775 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755079Ab3GPAOX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 20:14:23 -0400
Message-ID: <51E49036.5000901@zytor.com>
Date: Mon, 15 Jul 2013 17:13:42 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: David Woodhouse <dwmw2@infradead.org>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [Ksummit-2013-discuss] KS Topic request: Handling the Stable
 kernel, let's dump the cc: stable tag
References: <1373916476.2748.69.camel@dabdike> <20130715201943.GA22131@roeck-us.net> <1373925868.24167.35.camel@shinybook.infradead.org> <20130715220730.GA23916@roeck-us.net> <51E479D0.4040304@zytor.com> <20130715232209.GB24650@roeck-us.net>
In-Reply-To: <20130715232209.GB24650@roeck-us.net>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2013 04:22 PM, Guenter Roeck wrote:
> 
> I agree, _should_. But again, that is not the point I was trying to make.
> The keyword is _active_ decision vs. passive acceptance of a stable tag.
> 
> If the stable tag is not added by the maintainer, it can always be added to
> the stable queue after the code was pushed upstream. Nothing lost but a bit
> of convenience.
> 

... and yet another opportunity for things to fall between the cracks,
which is in my opinion MUCH more likely than something inappropriate
being tagged Cc: stable.

However, it doesn't seem to happen too often, but it does underscore the
need for a maintainer to be able to *retroactively* NAK a patch for
stable, if it is uncovered that it isn't appropriate after all.

	-hpa


