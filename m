Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753592AbaCKQCM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 12:02:12 -0400
Received: from www.linutronix.de ([62.245.132.108]:33316 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616AbaCKQCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 12:02:10 -0400
Date: Tue, 11 Mar 2014 17:02:04 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Paul Bolle <pebolle@tiscali.nl>
cc: "H. Peter Anvin" <hpa@zytor.com>,
        Jerome Oufella <jerome.oufella@savoirfairelinux.com>,
        Julian Wollrath <jwollrath@web.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RESEND] Fast TSC calibration fails with v3.14-rc1 and later
In-Reply-To: <1394492789.16134.36.camel@x220>
Message-ID: <alpine.DEB.2.02.1403111654340.18573@ionos.tec.linutronix.de>
References: <20140310110410.5b2218f6@ilfaris>  <1394447253.2979.12.camel@x220>  <alpine.DEB.2.02.1403101504590.18573@ionos.tec.linutronix.de>  <1394465314.12752.18.camel@x220>  <alpine.DEB.2.02.1403101757320.18573@ionos.tec.linutronix.de>  <1394476346.12752.43.camel@x220>
  <alpine.DEB.2.02.1403101956250.18573@ionos.tec.linutronix.de>  <1394479176.18058.10.camel@x41>  <alpine.DEB.2.02.1403102122310.18573@ionos.tec.linutronix.de> <1394492789.16134.36.camel@x220>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Mar 2014, Paul Bolle wrote:
> On Mon, 2014-03-10 at 21:50 +0100, Thomas Gleixner wrote:
> > Dammit no. We want to know WHY!
> 
> Here I am one and half year after reporting seeing this error. I'm not
> aware of anyone reporting it before me. Anyhow, I don't think things
> were working fine up to v3.13. And in my report (I'm not going to link

You can think what you want. 

According to Julian things were working fine for him and he actually
sat down and found out WHY things stopped working. That's what counts.

I really have a hard time to understand why you are wasting everyones
time with a completely pointless discussion about the printk level of
this particular thing. It's not spewing a backtrace. It's one line of
printk and there is no rule, that recoverable issues are not allowed
to be printed at KERN_ERR level. 

Julian noticed a change of behaviour due to that after 3.13. That's
way more important than your personal dislike of a particular error
level.

Thanks,

	tglx

