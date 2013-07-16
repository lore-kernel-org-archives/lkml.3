Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964771Ab3GPTnM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 15:43:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8885 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933827Ab3GPTnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 15:43:11 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=HICIQ9bjhMYA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=PINbNDQYIjoA:10 a=VwQbUJbxAAAA:8 a=giUcsLpzfsAtcDhQiWoA:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1374003789.6458.55.camel@gandalf.local.home>
Subject: Re: [Ksummit-2013-discuss] When to push bug fixes to mainline
From: Steven Rostedt <rostedt@goodmis.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Luck, Tony" <tony.luck@intel.com>, David Lang <david@lang.hm>,
        "ksummit-2013-discuss@lists.linux-foundation.org" 
	<ksummit-2013-discuss@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Willy Tarreau <w@1wt.eu>
Date: Tue, 16 Jul 2013 15:43:09 -0400
In-Reply-To: <20130716191147.GA1680@kroah.com>
References: <20130711214830.611455274@linuxfoundation.org>
	 <20130712005023.GB31005@thunk.org> <20130712051451.GC25815@1wt.eu>
	 <alpine.DEB.2.02.1307160017120.16723@nftneq.ynat.uz>
	 <s5hwqoqv4oo.wl%tiwai@suse.de> <20130716165933.GU22506@sirena.org.uk>
	 <3908561D78D1C84285E8C5FCA982C28F31C845B1@ORSMSX106.amr.corp.intel.com>
	 <CA+55aFzViZyMydimtes+a7neRRg1ibW5QUg3+bV2kjQASvgSpg@mail.gmail.com>
	 <1374000084.6458.36.camel@gandalf.local.home>
	 <20130716191147.GA1680@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-07-16 at 12:11 -0700, Greg Kroah-Hartman wrote:

> People mark stable patches that way already today with a:
> 	Cc: stable <stable@vger.kernel.org> # delay for 3.12-rc4
> or some such wording.  I take those and don't apply them until the noted
> release happens, so you can do this if needed.

I guess the thing is, are stable patches prone to regressions. Do we
just do that for patches that we think are too complex and may cause
some harm. Of course, there's the question about having a clue about
what patches might cause harm or not.

For tracing patches, I test them probably more than most people, as
tracing isn't usually done on non development machines. A regression in
tracing isn't likely to harm others.

Right now it doesn't seem to be an issue because we have "Greg" doing
things at light speed. But when stable is maintained by a lesser deity,
then we may need to look at changing the process.

-- Steve


