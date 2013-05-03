Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763832Ab3ECVc5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 17:32:57 -0400
Received: from mx2.3wh.net ([5.39.91.197]:55131 "EHLO mx2.3wh.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753960Ab3ECVc4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 17:32:56 -0400
X-Greylist: delayed 439 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 May 2013 17:32:56 EDT
Message-ID: <51842A5D.2070906@3wh.net>
Date: Fri, 03 May 2013 21:21:33 +0000
From: Nick <nick@3wh.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130403 Thunderbird/17.0.5
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: Fwd: PROBLEM: Random kernel panic & system freeze when watching
 video
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I experience a similar error on a Lenovo X201 notebook, maybe my 
information will help to identify the reason of the issue.
My mcelog output is:

MCE 0
CPU 2 BANK 2
TIME 1367614521 Fri May  3 20:55:21 2013
MCG status:
MCi status:
Uncorrected error
Error enabled
Processor context corrupt
MCA: Internal parity error
STATUS b200000000000005 MCGSTATUS 0
MCGCAP c09 APICID 4 SOCKETID 0
CPUID Vendor Intel Family 6 Model 37

The issue seem to be related to this particular model of notebook. The 
problem appears when starting Java applications and when a 
memory-hungry, but not a CPU-hungry Java process is launched. It never 
happened on simply a CPU-intensive task. The issue existed for a couple 
of years, but I didn't manage to get a MCE message before, it just hung. 
The same issue seems to exist with the same Lenovo model on a friend's 
notebook running Windows. At first I thought it is temperature related 
(as this Lenovo notebook seems some problems with fan control code), but 
it doesn't look like this. I set the fan to full speed manually, the 
error happens even when I'm in very cold environments, the notebook 
doesn't gets warm (subjectively), etc.

I'm posting this just to point out that this looks like some serial 
manufacturing issue that people should beware of or develop some way of 
early detection.

--- Previous message:
Feb 13, 2013; 6:27pm

On Wed, Feb 13, 2013 at 06:11:30PM +0000, Luck, Tony wrote:
 > > -- Panic DON'T happen when the laptop is running on battery. I've
 > > tried over 20 battery cycles (~40 hours) doing video playbacks and the
 > > computer never shut down.
 >
 > So my best guess is that you have a h/w problem aggravated by high 
temperatures.
 > When you are on battery the system will be saving power - which means 
less heat
 > dissipated by many components inside your laptop case.

One thing we haven't asked is whether you still have the warranty on
your hardware, and, if so, why not send it to the manufacturer so that
they can take a look at it - they should be much better than us software
guys and have the right tools for hardware inspection.

Thanks.

-- 
Regards/Gruss,
     Boris.

