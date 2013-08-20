Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751673Ab3HTIWV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 04:22:21 -0400
Received: from mail.skyhub.de ([78.46.96.112]:54997 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751382Ab3HTIWS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 04:22:18 -0400
Date: Tue, 20 Aug 2013 10:22:16 +0200
From: Borislav Petkov <bp@alien8.de>
To: Anton Arapov <anton@redhat.com>
Cc: Dave Jones <davej@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Greg KH <gregkh@linuxfoundation.org>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [ATTEND] oops.kernel.org prospect
Message-ID: <20130820082216.GA13078@pd.tnic>
References: <20130819085405.GA22328@bandura.laptop>
 <20130819145505.GB15178@kroah.com>
 <20130819151643.GC19070@bandura.laptop>
 <20130819153939.GA23875@thunk.org>
 <20130819155202.GF19070@bandura.laptop>
 <20130819212512.GA7918@redhat.com>
 <20130820080243.GB2613@bandura.laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130820080243.GB2613@bandura.laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 10:02:43AM +0200, Anton Arapov wrote:
> > * Visiting it with chromium gets an annoying warning about the https server
> > ...
> [snip]
> > ...
> > 	Dave
> 
> Thanks, Dave! Will be fixed and improved.

Yeah, collecting oopses is a good idea, so +1.

However, we probably want to think about what exactly we're going to
do with that information. For example, if I want to address an issue,
I probably want to know how I can reproduce the oops - maybe something
like allowing the reporter to add free text note to the oops.

And yes, as tytso already said, we are very often going to need more
info about a system causing the oops (dmesg, lspci, dmidecode, etc,
etc). I'm not sure how we're going to collect that without sacrificing
some privacy. Or maybe, we could be able to ask people to open a bug on
bugzilla.kernel.org where further debugging can take place...

Which reminds me: maybe connecting bug reports on bugzilla.kernel.org
with your stats could also be a way to connect bug reports with
reporters...

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
