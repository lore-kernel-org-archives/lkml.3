Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756904Ab3A3UAs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 15:00:48 -0500
Received: from mail.skyhub.de ([78.46.96.112]:34763 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756866Ab3A3UAp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 15:00:45 -0500
Date: Wed, 30 Jan 2013 21:00:41 +0100
From: Borislav Petkov <bp@alien8.de>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Bjorn Helgaas <bhelgaas@google.com>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Uhhuh. NMI received for unknown reason 2c on CPU 0.
Message-ID: <20130130200041.GD23895@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Jiri Slaby <jslaby@suse.cz>, Bjorn Helgaas <bhelgaas@google.com>,
	x86@kernel.org, lkml <linux-kernel@vger.kernel.org>,
	Konstantin Khlebnikov <khlebnikov@openvz.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>
References: <20130129202848.GE25415@pd.tnic>
 <CAErSpo4v473sXvmv3gqkftkiFZtz+gYgd1yzWae=nLJjwJPBug@mail.gmail.com>
 <20130130034204.GB30965@pd.tnic>
 <CAErSpo47BvEsDC1o_kYDeyd6j3VUoWHwSMYPyLpZYB1H-sL=7A@mail.gmail.com>
 <20130130174402.GB23980@pd.tnic>
 <510977FB.3030707@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <510977FB.3030707@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2013 at 08:43:55PM +0100, Jiri Slaby wrote:
> On 01/30/2013 06:44 PM, Borislav Petkov wrote:
> > On Wed, Jan 30, 2013 at 10:27:42AM -0700, Bjorn Helgaas wrote:
> >> You're right, I don't think we're quite ready to merge those patches.
> >> But if your NMI is easy to reproduce, it might be worth removing
> >> e1000e altogether to see if it still happens.
> > 
> > That's the problem - I've seen it only once so far. I'll watch out for
> > it and do the above when I find a reliable way of reproducing it. Will
> > keep you posted.
> 
> It happens here too. Dunno what is the root cause. I *think* that it
> never happened unless I used ethernet. Other than that I see no pattern.
> 
> Attaching -C 20 grep of messages over the last half year if there is
> something that may help somehow.

Cool, so it happens once a day, not every day, everytime during resume,
and with e1000e. Can you try Bjorn's suggestion to remove e1000e
altogether and see if it still happens?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
