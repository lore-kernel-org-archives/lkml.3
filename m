Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755095Ab3LEX0l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 18:26:41 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48802 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458Ab3LEX0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 18:26:39 -0500
Date: Thu, 5 Dec 2013 15:26:38 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Christopher Covington <cov@codeaurora.org>
Cc: Adrien =?iso-8859-1?Q?Verg=E9?= <adrienverge@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Randy Dunlap <rdunlap@infradead.org>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Subject: Re: [PATCH 0/3] ARM Coresight: Enhance ETM tracing control
Message-ID: <20131205232638.GC28396@kroah.com>
References: <20131204070442.GA31665@kroah.com>
 <CANsc=4UHEG5cmg9SD3r3rsuJnM9zqq2WiTQdUwrYFr_kkbsVvg@mail.gmail.com>
 <20131204170703.GA14859@kroah.com>
 <CANsc=4X7ThCvgz9bfu1ZZg9FCti5SMdbXL5tA584z-oZ_HEByg@mail.gmail.com>
 <20131204230239.GB9205@kroah.com>
 <CANsc=4UGi5sMdUW5qQDzEJx4h8NDU+-b=xOLBAZtzbV5ugz3Fg@mail.gmail.com>
 <20131205040104.GA14641@kroah.com>
 <52A0DE42.3080602@codeaurora.org>
 <20131205201659.GA14539@kroah.com>
 <52A101F8.3060104@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52A101F8.3060104@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 05, 2013 at 05:45:12PM -0500, Christopher Covington wrote:
> On 12/05/2013 03:16 PM, Greg Kroah-Hartman wrote:
> > On Thu, Dec 05, 2013 at 03:12:50PM -0500, Christopher Covington wrote:
> [...]
> > And adding new features to code that is "dead" and should probably be
> > removed isn't a good idea, as I'm sure you can understand.
> 
> I would consider feature additions to be a sign of life. Maybe the
> architecture or user interface isn't ideal, but would you suggest just as
> quickly for media codec or cryptography hardware support be removed?

No, but I would ask that they be moved to use the same userspace api
for the same functionality, and not create custom ones just because
"they can".

> > How much work is it to incorportate ETM into the perf framework?  Don't
> > you think that this is a better thing to do overall, instead of having
> > duplicating interfaces for the same thing?
> 
> I'm not familiar enough with the ETM hardware (and the ETB, the buffer where
> the data is stored) and driver to say. One factor may be whether the perf
> events framework would need to be extended for complete functionality or could
> be used as-is.

How about moving this conversation to the proper mailing list for this
type of thing then?

thanks,

greg k-h
