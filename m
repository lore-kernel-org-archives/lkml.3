Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759334Ab3DZGah (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 02:30:37 -0400
Received: from relay.medianet-world.de ([213.157.0.172]:39244 "HELO
	relay.medianet-world.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754093Ab3DZGag convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 02:30:36 -0400
thread-index: Ac5CR2J/CzlKnV4vScyVzrSjsSa66Q==
Thread-Topic: [ANNOUNCE] 3.4.41-rt55-feat1
Content-Class: urn:content-classes:message
Importance: normal
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.4913
From: "Tim Sander" <tim.sander@hbm.com>
To: "Thomas Gleixner" <tglx@linutronix.de>
Cc: "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>,
        "Steven Rostedt" <rostedt@goodmis.org>,
        "LKML" <linux-kernel@vger.kernel.org>,
        "RT" <linux-rt-users@vger.kernel.org>,
        "Carsten Emde" <C.Emde@osadl.org>, "John Kacur" <jkacur@redhat.com>
Subject: Re: [ANNOUNCE] 3.4.41-rt55-feat1
Date: Fri, 26 Apr 2013 08:29:19 +0200
Message-ID: <1583928.Wo0hVGhFvV@dabox>
Organization: Hottinger Baldwin Messtechnik
User-Agent: KMail/4.10.2 (Linux/3.8.0+; KDE/4.10.2; x86_64; ; )
In-Reply-To: <alpine.LFD.2.02.1304260018470.21884@ionos>
References: <1366760662.9609.176.camel@gandalf.local.home> <3603730.i3rZKahVeu@dabox> <alpine.LFD.2.02.1304260018470.21884@ionos>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
	charset="us-ascii"
X-OriginalArrivalTime: 26 Apr 2013 06:29:20.0190 (UTC) FILETIME=[626F5DE0:01CE4247]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas
> On Thu, 25 Apr 2013, Tim Sander wrote:
> > handler. But normally the HR_TIMER is set. So we switched it off on this
> > very purpose. As we also have also PREEMPT_RT_FULL set the proposed
> > solution to allow only PREEMPT_RT_FULL with PREEMPT_RT_FULL set is not an
> > option for us.
Dammit, that happens when one gets interrupted. The thoughts got a little 
scrambled on the way. Interestingly Steven understood my mental outflow (But he 
also likes reading this stupid legalese on the end of the mail, so he is 
probably not a reference ;-) )

What i meant to say is that PREEMPT_RT_FULL depending on HR_TIMERS is not an 
option for us for the reasons you already stated in this thread.

So while i can understand that you want to move forward, it would be nice if 
at least the stable-rt 3.4 series would be keept seperate from this feature 
patch in the future.

Well i would also like to test this stuff on this non HR_TIMER config but mainly 
to satify my own curiosity.

Best regards
Tim

Please ignore as alsway on public lists if you don't want to learn german 
legalese:




Hottinger Baldwin Messtechnik GmbH, Im Tiefen See 45, 64293 Darmstadt, Germany | www.hbm.com 

Registered as GmbH (German limited liability corporation) in the commercial register at the local court of Darmstadt, HRB 1147  
Company domiciled in Darmstadt | CEO: Andreas Huellhorst | Chairman of the board: James Charles Webster

Als Gesellschaft mit beschraenkter Haftung eingetragen im Handelsregister des Amtsgerichts Darmstadt unter HRB 1147 
Sitz der Gesellschaft: Darmstadt | Geschaeftsfuehrung: Andreas Huellhorst | Aufsichtsratsvorsitzender: James Charles Webster

The information in this email is confidential. It is intended solely for the addressee. If you are not the intended recipient, please let me know and delete this email.

Die in dieser E-Mail enthaltene Information ist vertraulich und lediglich fur den Empfaenger bestimmt. Sollten Sie nicht der eigentliche Empfaenger sein, informieren Sie mich bitte kurz und loeschen diese E-Mail.
