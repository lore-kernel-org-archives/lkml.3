Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753098AbaCJXGd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 19:06:33 -0400
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:50257 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752213AbaCJXGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 19:06:31 -0400
Message-ID: <1394492789.16134.36.camel@x220>
Subject: Re: [RESEND] Fast TSC calibration fails with v3.14-rc1 and later
From: Paul Bolle <pebolle@tiscali.nl>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Jerome Oufella <jerome.oufella@savoirfairelinux.com>,
        Julian Wollrath <jwollrath@web.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 11 Mar 2014 00:06:29 +0100
In-Reply-To: <alpine.DEB.2.02.1403102122310.18573@ionos.tec.linutronix.de>
References: <20140310110410.5b2218f6@ilfaris>
	 <1394447253.2979.12.camel@x220>
	 <alpine.DEB.2.02.1403101504590.18573@ionos.tec.linutronix.de>
	 <1394465314.12752.18.camel@x220>
	 <alpine.DEB.2.02.1403101757320.18573@ionos.tec.linutronix.de>
	 <1394476346.12752.43.camel@x220>
	 <alpine.DEB.2.02.1403101956250.18573@ionos.tec.linutronix.de>
	 <1394479176.18058.10.camel@x41>
	 <alpine.DEB.2.02.1403102122310.18573@ionos.tec.linutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Mar 2014 23:06:29.0603 (UTC) FILETIME=[5EE7CB30:01CF3CB5]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-03-10 at 21:50 +0100, Thomas Gleixner wrote:
> On Mon, 10 Mar 2014, Paul Bolle wrote:
> > So could you please consider downgrading this message?
> >
> > Yes, this will make regressions less visible, although I'm unsure we're
> > actually seeing a regression here. But I think that this is better than
> > scaring people about a situation they can't easily do something about,
> > if at all. Especially since fast TSC calibration failures, apparently,
> > can be worked around.
> 
> If something works fine from version X up to v3.13 and then suddenly
> fails, then we can safely ignore it because there is a work around or
> fallback? And just shrug and say: Oh, it's not a regression.

That's not what I said, not at all. Saying that "I'm unsure we're
actually seeing a regression" is not shrugging it off.
 
> Dammit no. We want to know WHY!

Here I am one and half year after reporting seeing this error. I'm not
aware of anyone reporting it before me. Anyhow, I don't think things
were working fine up to v3.13. And in my report (I'm not going to link
to it again) I suggested to downgrade this message. My exact words were:
    So, without even understanding why tsc calibration is needed, it does
    look unnecessary to print "Fast TSC calibration failed" at error level.
    If that's correct, I'd be happy to submit the trivial patch to downgrade
    it to (say) informational level.

Which was fine with hpa (added in CC).

I actually submitted that patch, sent a reminder, and Jerome sent a
similar patch. Most of that was directly sent to you too. I don't think
we got any reaction whatsoever. And, still, suggesting this is not a
regression and reiterating that this could also be printed at something
else than error level somehow provoked your outburst.

I'd like to discuss a way forward. But could you please _try_ to
understand why I said what I said in this discussion?


Paul Bolle

