Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751679AbaF0QbR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 12:31:17 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:45394 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751246AbaF0QbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 12:31:15 -0400
Date: Fri, 27 Jun 2014 17:31:08 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Fredrik Noring <fredrik.noring@autoliv.com>
Cc: Mattis Lorentzon <Mattis.Lorentzon@autoliv.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: Oops: 17 SMP ARM (v3.16-rc2)
Message-ID: <20140627163108.GP32514@n2100.arm.linux.org.uk>
References: <C4A61A5CA4AD2246942F4BA6F20ACB804356534D@ALVA-EXMB04.alv.autoliv.int> <20140626140115.GQ32514@n2100.arm.linux.org.uk> <C4A61A5CA4AD2246942F4BA6F20ACB80435655E9@ALVA-EXMB04.alv.autoliv.int> <20140626151424.GT32514@n2100.arm.linux.org.uk> <20140627112151.GF32514@n2100.arm.linux.org.uk> <3FFB61A7A8473C49831AF20FA193534A43CADFA7@ALVA-EXMB01.alv.autoliv.int>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3FFB61A7A8473C49831AF20FA193534A43CADFA7@ALVA-EXMB01.alv.autoliv.int>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Fredrik,

On Fri, Jun 27, 2014 at 04:16:57PM +0000, Fredrik Noring wrote:
> Please find below a trace that appeared once with 3.16-rc2. Perhaps it is of
> some interest?

It's not that serious... I know that the FEC ethernet driver is
horrendously racy (I have had a patch set for about the last six months
which fixes some of its problems) but as I've had a lot of patches to
deal with, and it's been pushed to the back of the queue...

The races don't lead to data corruption though, merely timeouts and
some lost packets.

Now because things have changed during the last merge window, I've got
an even bigger problem sorting through that patch set and getting it
back into a submittable state.  I've just sent out v2 for it onto the
netdev@vger.kernel.org mailing list.

The initial version (marked RFC) attracted very little interest from
testers, or acks.  I'd very much like to have some testing of it, so
if you want to try it out, I can provide you with a git URL, patches
or a combined patch.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
