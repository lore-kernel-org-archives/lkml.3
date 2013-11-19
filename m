Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751666Ab3KSJVi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 04:21:38 -0500
Received: from nebula.mojo.cc ([46.4.89.19]:35500 "EHLO nebula.mojo.cc"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751396Ab3KSJVg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 04:21:36 -0500
From: "MPhil. Emanoil Kotsev" <Emanoil.Kotsev@fincom.at>
Organization: FinCom Consulting
To: Borislav Petkov <bp@alien8.de>
Subject: Re: [Intel-gfx] kernel 3.11.6 general protection fault
Date: Tue, 19 Nov 2013 10:21:09 +0100
User-Agent: KMail/1.9.10 (enterprise35 0.20100827.1168748)
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel@ffwll.ch>
References: <201311132058.30310.Emanoil.Kotsev@fincom.at> <201311171745.19339.Emanoil.Kotsev@fincom.at> <20131117200546.GP27323@pd.tnic>
In-Reply-To: <20131117200546.GP27323@pd.tnic>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201311191021.10095.Emanoil.Kotsev@fincom.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Sunday 17 November 2013 21:05:46 Borislav Petkov wrote:
> On Sun, Nov 17, 2013 at 05:45:18PM +0100, MPhil. Emanoil Kotsev wrote:
> > How - new libraries - more exhaustive algorythms - higher cpu usage
> > etc. Some of the things M$ is doing on purpose to force you upgrade
> > your hardware every 2-3years
>
> That would be too easy and machines would be dying left and right of
> overheating. Actually, sane hardware is much more robust than that and
> it throttles itself in case of critical temperature levels. And, IMHO
> your Dell Latitude D520 should be fine, in that respect. But we'll see.
>

I was thinking the same - but started to despair

> :-)
> :
> > I wanted to first compile the kernel with the debug option you
> > mentioned, but while compiling it went to about 75°C.
>
> Yeah, that's still ok if we trust the output saying that 126°C is the
> critical temp.
>
> It would be interesting to see what this sensor says right before the
> machine locks up.

This test is outstanding for a moment where I have more free time to reproduce 
and log everything

I did something else yesterday evening before going to bed ~00:30
I closed the  notebook cover just so that it would switch off the LCD display
In the morning I opened up and found the notebook with blinking led lights 

http://www.dell.com/support/troubleshooting/us/en/19/KCS/KcsArticles/ArticleView?c=us&l=en&s=dhs&docid=DSN_DBECF64CFEDA449398CB9E859D4944A5

unfortunately I don't find the pattern in the link above
the left one was on and the other two were blinking

Arter shut down (keep power button pressed) and turning it on only the two 
leds (middle and right) were blinking, which according the link above means 

Configuring PCI bridges	Replacing the system board.

After waiting for about 1-2mins notebook starts normally - another link to 
heating issues.

At the moment I have to do pretty much at all levels, so I can not test any 
further.
This is just an update. I'll post again when more results are available.
I'm thinking to open up and inspect from inside - perhaps somewhere the 
cooling system is clogged or something.

regards

