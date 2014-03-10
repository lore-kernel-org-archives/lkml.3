Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450AbaCJTTm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 15:19:42 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:51916 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754415AbaCJTTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 15:19:39 -0400
Message-ID: <1394479176.18058.10.camel@x41>
Subject: Re: [RESEND] Fast TSC calibration fails with v3.14-rc1 and later
From: Paul Bolle <pebolle@tiscali.nl>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jerome Oufella <jerome.oufella@savoirfairelinux.com>,
        Julian Wollrath <jwollrath@web.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 10 Mar 2014 20:19:36 +0100
In-Reply-To: <alpine.DEB.2.02.1403101956250.18573@ionos.tec.linutronix.de>
References: <20140310110410.5b2218f6@ilfaris>
	 <1394447253.2979.12.camel@x220>
	 <alpine.DEB.2.02.1403101504590.18573@ionos.tec.linutronix.de>
	 <1394465314.12752.18.camel@x220>
	 <alpine.DEB.2.02.1403101757320.18573@ionos.tec.linutronix.de>
	 <1394476346.12752.43.camel@x220>
	 <alpine.DEB.2.02.1403101956250.18573@ionos.tec.linutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Mar 2014 19:19:37.0312 (UTC) FILETIME=[AD590600:01CF3C95]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner schreef op ma 10-03-2014 om 19:57 [+0100]:
> On Mon, 10 Mar 2014, Paul Bolle wrote:
> > 
> > Or is there a way to handle the "SMI nonsense" (whatever that may be)?
> 
> No, there is none. That's "value add" from the BIOS/board manufacturer
> which utilizes the System Management Interrupt and steals CPU time
> from the OS.

So could you please consider downgrading this message?

Yes, this will make regressions less visible, although I'm unsure we're
actually seeing a regression here. But I think that this is better than
scaring people about a situation they can't easily do something about,
if at all. Especially since fast TSC calibration failures, apparently,
can be worked around.


Paul Bolle

