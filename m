Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758106Ab3GYTcN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 15:32:13 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:19721 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756625Ab3GYTcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 15:32:10 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18eC8GaScPqIMX39XJkutQKqkSET0W29bw=
Date: Thu, 25 Jul 2013 15:31:35 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Rob Herring <robherring2@gmail.com>
Cc: Olof Johansson <olof@lixom.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "ksummit-2013-discuss@lists.linuxfoundation.org" 
	<ksummit-2013-discuss@lists.linuxfoundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Domenico Andreoli <cavokz@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave P Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: DT bindings as ABI [was: Do we have people interested in
 device tree janitoring / cleanup?]
Message-ID: <20130725193135.GT23879@titan.lakedaemon.net>
References: <CAOesGMhJ+je8FZqeFxhAcYwU0CHYer+aGP6DA_8x3azrzfA2sw@mail.gmail.com>
 <CAL_JsqJQWOLC9f1igEpsgJB2X8mFDpqLDaFFRjGGVHctjWZLgQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL_JsqJQWOLC9f1igEpsgJB2X8mFDpqLDaFFRjGGVHctjWZLgQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 02:11:31PM -0500, Rob Herring wrote:
> On Thu, Jul 25, 2013 at 11:09 AM, Olof Johansson <olof@lixom.net> wrote:

> > One problem that needs to be solved is obviously how a binding
> > graduates from tentative to locked. This work isn't going to be very
> > interesting to most people, I suspect. Think standards committee type
> > work.
> 
> I think a time based stabilization period would be better than a
> separate directory to apply bindings too. Or time plus periodic review
> perhaps.

The only problem with a time-based versus separate directory is how do
users who've downloaded the tree determine which bindings are stable?
If they pull a tarball, or receive an SDK, there is most likely no git
history attached.

I think the idea of a 'tentative' directory (or 'locked') is churnish,
but necessary.  If I DL'd a tarball and had to type 'tentative' to get
to the binding doc I wanted, that would be a pretty clear clue to be
delicate about how I trust/use/plan with that binding.

thx,

Jason.
