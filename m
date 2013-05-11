Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927Ab3EKOJb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 May 2013 10:09:31 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:63230 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751Ab3EKOJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 May 2013 10:09:30 -0400
Date: Sat, 11 May 2013 16:09:25 +0200
From: Heinz Diehl <htd@fritha.org>
To: Frantisek Hrbata <fhrbata@redhat.com>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-usb@vger.kernel.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        dzickus@redhat.com, kernel-team@fedoraproject.org
Subject: Re: NULL pointer dereference in xhci_free_dev
Message-ID: <20130511140925.GA9240@fritha.org>
References: <20130507140333.GB3380@dhcp-26-164.brq.redhat.com>
 <20130509221559.GD10305@xanatos>
 <20130510065644.GA3320@dhcp-26-164.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130510065644.GA3320@dhcp-26-164.brq.redhat.com>
Organization: private site
OpenPGP: id=BBAD7AE7; url=http://www.fritha.org/htd.asc
User-Agent: Mutt/1.5.21+155 (d3096e8796e7) (2012-12-30)
X-Provags-ID: V02:K0:4Xo/TdGNjbpfSAXDj/uDXlT7/Jhg+pgoxzU/u29UgjH
 4TIxKz29pTjhxbXu9xoDWpaeLWlIcgGHel1w3M2k073jfpCbYv
 j9h4ifuj7POJsHZGm5/njJiwlPHMkt/r6iTlEfY3AHfwbtc/WQ
 5Z9aT9+XUQMjbUg5uzQ9oQ6zMii8/ESzyEck1UC+e2Dbyc1u+F
 wn7ZQOeZDtyfX86ujuVKq5/ff1eNdKnYA+k0iuclnLz8j5GHe3
 oubPffzpRt0ibkckYubxSJjFrIf/4/ixFVXQRDwHYirOR8OCp7
 iJHyDHGf4IU3kemdi5lPtD9qUlH1KIAo1RYXnWcxAMak7CPxXS
 xegpz/SHTAcuke3lOLJc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11.05.2013, Frantisek Hrbata wrote: 

> I haven't tried to reproduce. I was asked to help with Fedora's bugs triage and
> these come up. The goal was just to contact the right people and bring this to
> their attention. If you have a patch for this, I guess we can try to ask Heinz,
> or other people reporting this problem, to help with testing.

I'm willing to help, of course. I'll try to install latest 3.9 on the
machine this bug occurs and see if I manage to reproduce it. As far as
I remember, it happened when I changed some USB 2.0 devices on an USB
3 port. The machine is re-installed and runs F18 now.
 
> Heinz: Sorry I forgot to add you to CC in the first mail, but Sarah fixed it.

Never mind, I'm subscribed to lkml and saw the thread there ;-)

