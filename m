Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350AbaCZOqT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 10:46:19 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:61171 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754339AbaCZOqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 10:46:18 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Kieran Clancy <clancy.kieran@gmail.com>
Cc: Stefan Biereigel <stefan@biereigel.de>,
        Juan Manuel Cabo <juanmanuel.cabo@gmail.com>,
        Stefan Biereigel <security@biereigel-wb.de>,
        Lan Tianyu <lantianyu1986@gmail.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger kernel org" <linux-kernel@vger.kernel.org>,
        Len Brown <lenb@kernel.org>, San Zamoyski <san@plusnet.pl>,
        "D. Jansen" <dennis.jansen@web.de>,
        "Maurizio D'Addona" <mauritiusdadd@gmail.com>
Subject: Re: [REGRESSION 3.14-rc6] Samsung N150 lid does not "open" after suspend to RAM.
Date: Wed, 26 Mar 2014 16:01:56 +0100
Message-ID: <4534478.UfDZjzQsar@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAGf84QJU+RKXV4AyQ7QBTKjpdPm3AYLtWTFio+-r3j8wyoEokA@mail.gmail.com>
References: <532FE3B2.9060808@biereigel-wb.de> <5332AF10.90109@biereigel.de> <CAGf84QJU+RKXV4AyQ7QBTKjpdPm3AYLtWTFio+-r3j8wyoEokA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, March 27, 2014 01:08:58 AM Kieran Clancy wrote:
> On Wed, Mar 26, 2014 at 9:12 PM, Stefan Biereigel <stefan@biereigel.de> wrote:
> >
> > I don't know if it is a valid idea, but maybe it would be ok to process
> > events after resume in general, and only throw away events on those
> > platforms that continue to log events while in standby (Samsung 5/7/9)?
> 
> We can give it a shot!
> 
> It may even be that on Samsung 5/7/9 there is no harm in processing
> the events instead of discarding them.
> 
> Here's a patch that we can try for that:
> 
> http://kieranclancy.com/tmp/2014/03/ec_clear_process.patch

Can you please send patches inline so that it's more convenient to
comment them if need be?

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
