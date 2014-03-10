Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182AbaCJP2h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 11:28:37 -0400
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:61064 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753930AbaCJP2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 11:28:36 -0400
Message-ID: <1394465314.12752.18.camel@x220>
Subject: Re: [RESEND] Fast TSC calibration fails with v3.14-rc1 and later
From: Paul Bolle <pebolle@tiscali.nl>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Julian Wollrath <jwollrath@web.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 10 Mar 2014 16:28:34 +0100
In-Reply-To: <alpine.DEB.2.02.1403101504590.18573@ionos.tec.linutronix.de>
References: <20140310110410.5b2218f6@ilfaris>
	 <1394447253.2979.12.camel@x220>
	 <alpine.DEB.2.02.1403101504590.18573@ionos.tec.linutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Mar 2014 15:28:34.0753 (UTC) FILETIME=[669E6310:01CF3C75]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-03-10 at 15:06 +0100, Thomas Gleixner wrote:
> And how is this related to Julians observation, that fast calibration
> works in 3.13, but stopped to work in 3.14-rc ?

In the rest of my message - which you didn't quote - I stated that "the
error need not be v3.14-rc1 specific. But perhaps something changed in
v3.14-rc1 that makes it easier to trigger that error. I haven't
checked". (I didn't add that, in my experience, this message is not seen
at every boot.) So I'm basically advising Julian to double check whether
this is really a change in behavior between v3.13 and v3.14-rc1. But
perhaps Julian already did.

And I'm also telling Julian that, as far as I can tell, there's no
reason to print this message at KERN_ERR level because what subsequently
will happen is that an alternative calibration strategy is tried. So a
failure of fast TSC calibration is apparently not so severe. See
https://lkml.org/lkml/2012/9/24/221 . Is that analysis incorrect?

Thanks,


Paul Bolle

