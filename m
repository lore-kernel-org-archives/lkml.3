Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211AbaKEP4G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 10:56:06 -0500
Received: from bagpuss.pepperfish.net ([148.251.8.16]:47907 "EHLO
	bagpuss.pepperfish.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754835AbaKEP4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 10:56:03 -0500
X-Greylist: delayed 571 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Nov 2014 10:56:03 EST
Date: Wed, 5 Nov 2014 15:46:25 +0000
From: Daniel Silverstone <dsilvers@digital-scurf.org>
To: Nix <nix@esperi.org.uk>
Cc: Johan Hovold <johan@kernel.org>, Paul Martin <pm@debian.org>,
        Daniel Silverstone <dsilvers@debian.org>,
        Oliver Neukum <oliver@neukum.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [3.16.1 BISECTED REGRESSION]: Simtec Entropy Key (cdc-acm)
 broken in 3.16
Message-ID: <20141105154625.GT6592@somnambulist.local>
References: <20141012185845.GB2786@localhost>
 <878uklynq9.fsf@spindle.srvr.nix>
 <20141014083432.GB7958@localhost>
 <871tq04fiy.fsf@spindle.srvr.nix>
 <20141022101458.GK2113@localhost>
 <87y4s8yv38.fsf@spindle.srvr.nix>
 <20141024111442.GA19377@localhost>
 <87d298i3y9.fsf@spindle.srvr.nix>
 <20141105115643.GR31358@localhost>
 <87vbmtbrx2.fsf@spindle.srvr.nix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87vbmtbrx2.fsf@spindle.srvr.nix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2014 at 15:14:49 +0000, Nix wrote:
> > Did you get anywhere with trying to look at the device firmware?
> Look at it? Only Daniel Silverstone (Cc:ed) can do that. The only copy
> of the firmware I have is baked into the sealed key. :)

Sadly I can't look at the exact firmware of the device, but I can tell you it
was based on ST Electronics' virtual COM port example in their *old* STM32
development kits.

Fortunately I do have a record of that example code here:
https://git.gitano.org.uk/stm32-virtcomport.git/

I'm not a USB guru though.

D.

-- 
Daniel Silverstone                         http://www.digital-scurf.org/
PGP mail accepted and encouraged.            Key Id: 3CCE BABE 206C 3B69
