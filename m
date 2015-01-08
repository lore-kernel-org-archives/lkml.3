Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641AbbAHCWj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 21:22:39 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:48676 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789AbbAHCWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 21:22:37 -0500
X-AuditID: cbfee68f-f791c6d000004834-17-54ade9eb4157
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Jiri Kosina'" <jkosina@suse.cz>
Cc: "'Stephen Rothwell'" <sfr@canb.auug.org.au>,
        "'Josh Poimboeuf'" <jpoimboe@redhat.com>,
        "'Christoph Hellwig'" <hch@infradead.org>,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        linux-next@vger.kernel.org, "'Steven Rostedt'" <rostedt@goodmis.org>,
        "'Masami Hiramatsu'" <masami.hiramatsu.pt@hitachi.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <alpine.LNX.2.00.1412221412360.1680@pobox.suse.cz>
 <20141223094607.GA16445@infradead.org>
 <20141223151056.GA4789@treble.redhat.com>
 <20141226155613.36dd95b9@canb.auug.org.au>
 <20150107144317.61ab2080877a4d8227990551@linux-foundation.org>
 <alpine.LNX.2.00.1501072346400.15299@pobox.suse.cz>
 <20150107153006.60ed354e3458f402e6819b9e@linux-foundation.org>
 <alpine.LNX.2.00.1501080037030.15299@pobox.suse.cz>
 <20150107155701.4839545f63701412003edd88@linux-foundation.org>
 <alpine.LNX.2.00.1501080104190.15299@pobox.suse.cz>
 <20150107163345.ae3ed8f2e4501e258ff01512@linux-foundation.org>
In-reply-to: <20150107163345.ae3ed8f2e4501e258ff01512@linux-foundation.org>
Subject: Re: livepatching tree for linux-next
Date: Thu, 08 Jan 2015 11:22:32 +0900
Message-id: <000601d02ae9$f56e0880$e04a1980$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AdAq2sT+fsi7jl81T9OwEnSFi1SFtQADnevg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHIsWRmVeSWpSXmKPExsWyRsSkVff1y7UhBq8PcFrMWb+GzeL0hEVM
	FpcXXmK12D1nMYvFgZ8nGC0u75rDZnFwYRujxZmD99gs1u9dw2Sxr+MBk8XWvVfZHbg9Gm/c
	YPNo2XeL3aP1zBoWj80rtDxOzPjN4vF+31U2j74tqxg9ziw4wu7xeZNcAGcUl01Kak5mWWqR
	vl0CV8bHq28YC1ZwV1x4uYOtgfEaRxcjJ4eEgIlE88aJLBC2mMSFe+vZuhi5OIQEljJKbLw0
	gQWm6FBfNzNEYjqjxM7n78ASQgK/GCVam2JAbDYBNYkvXw6zg9giAgES/95PYwFpYBZ4yiSx
	aNYGRojuZywSD79dZgSp4hTwlth4dClYh7CArsTrRz+YQWwWAVWJM3PnsILYvAK2EjPXTWeD
	sAUlfky+B7aZWUBLYvO2JlYIW15i85q3QL0cQKeqSzz6qwtxhJHEtzcQBzELiEjse/GOEeKb
	lRwSZ7t0IFYJSHybfIgFolVWYtMBZogSSYmDK26wTGCUmIVk8Swki2chWTwLyYYFjCyrGEVT
	C5ILipPSi4z1ihNzi0vz0vWS83M3MQKTwel/z/p3MN49YH2IUYCDUYmH98P9tSFCrIllxZW5
	hxhNgS6ayCwlmpwPTDl5JfGGxmZGFqYmpsZG5pZmSuK8C6V+BgsJpCeWpGanphakFsUXleak
	Fh9iZOLglGpgnPqBPypg3+E3qZmLXr6uq6p9K2X6dfv0hS1brLMbZm6/EPXDNdXiaPHnR+vD
	dx1bMUP5qP+ro1lmKmlfC9uEcrrO7DNzTb8x94CCeoTRRrv31w5zxXjzKZsVcx3s57hmyLx5
	nmFK4cpldnXXVzMVNfhccQ9+NaN7v/3HvOPpS7SK1+kUB3uVKLEUZyQaajEXFScCADIzc00B	AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJKsWRmVeSWpSXmKPExsVy+t9jQd3XL9eGGDy/zGwxZ/0aNovTExYx
	WVxeeInVYvecxSwWB36eYLS4vGsOm8XBhW2MFmcO3mOzWL93DZPFvo4HTBZb915ld+D2aLxx
	g82jZd8tdo/WM2tYPDav0PI4MeM3i8f7fVfZPPq2rGL0OLPgCLvH501yAZxRDYw2GamJKalF
	Cql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUDnKimUJeaUAoUCEouL
	lfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ6xgzPl59w1iwgrviwssdbA2M1zi6GDk5JARMJA71
	dTND2GISF+6tZ+ti5OIQEpjOKLHz+TsWkISQwC9GidamGBCbTUBN4suXw+wgtohAgMS/99NY
	QBqYBZ4ySSyatYERovsZi8TDb5cZQao4BbwlNh5dCtYhLKAr8frRD7B1LAKqEmfmzmEFsXkF
	bCVmrpvOBmELSvyYfA9sM7OAlsTmbU2sELa8xOY1b4F6OYBOVZd49FcX4ggjiW9vIA5iFhCR
	2PfiHeMERqFZSCbNQjJpFpJJs5C0LGBkWcUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kRnGye
	Se9gXNVgcYhRgINRiYf3w/21IUKsiWXFlbmHGCU4mJVEeJOfAIV4UxIrq1KL8uOLSnNSiw8x
	mgI9OpFZSjQ5H5gI80riDY1NzIwsjcwsjEzMzZXEeZXs20KEBNITS1KzU1MLUotg+pg4OKUa
	GLcqSXakdKVuNGbTXX67cXF7YnBd2WnN8xO5nzYX35l+7PiMX5l8wcWnNJZrzP9ldlu86dvp
	B5sv/nlj8raB8/tHLcFFZ6x4JTfkdr6q4lkbN0mvKH7v2inxDc/u/F7C0nJnxUarr+8fCjmk
	X6wraV4855xk8/ntadoHDI64px+7eFr2npTMr7NKLMUZiYZazEXFiQAuFlTYTAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, January 08, 2015 9:34 AM, Andrew Morton wrote:
> On Thu, 8 Jan 2015 01:11:03 +0100 (CET) Jiri Kosina <jkosina@suse.cz> wrote:
> 
> > On Wed, 7 Jan 2015, Andrew Morton wrote:
> >
> > > > --- a/kernel/livepatch/core.c
> > > > +++ b/kernel/livepatch/core.c
> > > > @@ -911,6 +911,12 @@ static int klp_init(void)
> > > >  {
> > > >  	int ret;
> > > >
> > > > +	ret = klp_check_compiler_support();
> > > > +	if (ret) {
> > > > +		pr_info("Your compiler is too old; turning off.\n");
> > > > +		return -EINVAL;
> > > > +	}
> > > > +
> > >
> > > Looks reasonable.
> >
> > Thanks. Can I treat this as your Reported-and-tested-by .. ?
> 
> I compile tested it.  Then I got bored trying to hunt down all the
> Kconfig things I needed to turn on to runtime test it ;)
> 
> btw, I suggest using HAVE_LIVE_PATCHING instead of
> ARCH_HAVE_LIVE_PATCHING.  because this:

I agree with your opinion. :-)
Using 'HAVE_LIVE_PATCHING' looks better.

Best regards,
Jingoo Han

> 
> akpm3:/usr/src/25> grep " HAVE_" arch/x86/Kconfig | wc -l
> 67
> akpm3:/usr/src/25> grep " ARCH_HAVE_" arch/x86/Kconfig | wc -l
> 3
> akpm3:/usr/src/25> grep " ARCH_HAS_" arch/x86/Kconfig | wc -l
> 7
> akpm3:/usr/src/25> grep " HAVE_ARCH" arch/x86/Kconfig | wc -l
> 8
> akpm3:/usr/src/25> grep " ARCH_USE" arch/x86/Kconfig | wc -l
> 4
> akpm3:/usr/src/25> grep " ARCH_WANT" arch/x86/Kconfig | wc -l
> 6
> 
> makes me cry.


