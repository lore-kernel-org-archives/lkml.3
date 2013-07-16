Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933597Ab3GPSl2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 14:41:28 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9585 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754926Ab3GPSl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 14:41:26 -0400
X-Authority-Analysis: v=2.0 cv=Tr1kdUrh c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=HICIQ9bjhMYA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=PINbNDQYIjoA:10 a=FVbBZQTZ-KdV-D4Qd6kA:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1374000084.6458.36.camel@gandalf.local.home>
Subject: Re: [Ksummit-2013-discuss] When to push bug fixes to mainline
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Luck, Tony" <tony.luck@intel.com>, David Lang <david@lang.hm>,
        "ksummit-2013-discuss@lists.linux-foundation.org" 
	<ksummit-2013-discuss@lists.linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Willy Tarreau <w@1wt.eu>
Date: Tue, 16 Jul 2013 14:41:24 -0400
In-Reply-To: <CA+55aFzViZyMydimtes+a7neRRg1ibW5QUg3+bV2kjQASvgSpg@mail.gmail.com>
References: <20130711214830.611455274@linuxfoundation.org>
	 <20130712005023.GB31005@thunk.org> <20130712051451.GC25815@1wt.eu>
	 <alpine.DEB.2.02.1307160017120.16723@nftneq.ynat.uz>
	 <s5hwqoqv4oo.wl%tiwai@suse.de> <20130716165933.GU22506@sirena.org.uk>
	 <3908561D78D1C84285E8C5FCA982C28F31C845B1@ORSMSX106.amr.corp.intel.com>
	 <CA+55aFzViZyMydimtes+a7neRRg1ibW5QUg3+bV2kjQASvgSpg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-07-16 at 11:29 -0700, Linus Torvalds wrote:

> Anyway, the point I'm making is that Q&A is limited and often even
> actively misleading ("Hey, I have three tested-by's, so it must be
> fine"), and we might actually want to have a new class of
> "non-critical patch that might be worth backporting to stable, but
> only do so after it's been in a release for some time". Because while
> it might be an "obvious" fix, maybe it's not critical enough that it
> needs to be backported _now_ - maybe it could wait a month or two, and
> get wider testing.

Should we add another stable tag?

Have the default Cc: stable have to wait a rc or two in mainline before
it makes its way to the stable tree. Have a stable-critical for those
that are bugs that are security fixes than need to be backported ASAP.

-- Steve


