Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756902Ab3LFAZN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 19:25:13 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:44034 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753003Ab3LFAZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 19:25:10 -0500
Date: Fri, 6 Dec 2013 00:23:45 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Adrien =?iso-8859-1?Q?Verg=E9?= <adrienverge@gmail.com>,
        Christopher Covington <cov@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Subject: Re: [PATCH 0/3] ARM Coresight: Enhance ETM tracing control
Message-ID: <20131206002345.GK4360@n2100.arm.linux.org.uk>
References: <20131204170703.GA14859@kroah.com> <CANsc=4X7ThCvgz9bfu1ZZg9FCti5SMdbXL5tA584z-oZ_HEByg@mail.gmail.com> <20131204230239.GB9205@kroah.com> <CANsc=4UGi5sMdUW5qQDzEJx4h8NDU+-b=xOLBAZtzbV5ugz3Fg@mail.gmail.com> <20131205040104.GA14641@kroah.com> <52A0DE42.3080602@codeaurora.org> <20131205201659.GA14539@kroah.com> <52A101F8.3060104@codeaurora.org> <CANsc=4Vb-2br+K51NWsyQV25R3eJo_=YfpnXsh1G1ecRVDYc3w@mail.gmail.com> <20131206000610.GA30344@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131206000610.GA30344@kroah.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 05, 2013 at 04:06:10PM -0800, Greg Kroah-Hartman wrote:
> On Thu, Dec 05, 2013 at 06:54:49PM -0500, Adrien Vergé wrote:
> > > Well, these patches were incorrect, so that's not really a valid
> > > question :)
> > 
> > Should I correct the pid size and send them again?
> 
> I'm not the ARM maintainer, so I can't say if I would reject them or
> not.

Neither am I someone who knows this code; it was contributed by TI, and
I assume TI had I use for it.  I've no idea what that was or how it's
even used - it's not something I particularly care about.

I'd much rather someone else who has a use for ETM (and thus knows what
it should/can do) look after it.
