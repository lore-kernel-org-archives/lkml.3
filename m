Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756760Ab3LFAGO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 19:06:14 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:49215 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756081Ab3LFAGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 19:06:11 -0500
Date: Thu, 5 Dec 2013 16:06:10 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Adrien =?iso-8859-1?Q?Verg=E9?= <adrienverge@gmail.com>
Cc: Christopher Covington <cov@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Randy Dunlap <rdunlap@infradead.org>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Subject: Re: [PATCH 0/3] ARM Coresight: Enhance ETM tracing control
Message-ID: <20131206000610.GA30344@kroah.com>
References: <CANsc=4UHEG5cmg9SD3r3rsuJnM9zqq2WiTQdUwrYFr_kkbsVvg@mail.gmail.com>
 <20131204170703.GA14859@kroah.com>
 <CANsc=4X7ThCvgz9bfu1ZZg9FCti5SMdbXL5tA584z-oZ_HEByg@mail.gmail.com>
 <20131204230239.GB9205@kroah.com>
 <CANsc=4UGi5sMdUW5qQDzEJx4h8NDU+-b=xOLBAZtzbV5ugz3Fg@mail.gmail.com>
 <20131205040104.GA14641@kroah.com>
 <52A0DE42.3080602@codeaurora.org>
 <20131205201659.GA14539@kroah.com>
 <52A101F8.3060104@codeaurora.org>
 <CANsc=4Vb-2br+K51NWsyQV25R3eJo_=YfpnXsh1G1ecRVDYc3w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANsc=4Vb-2br+K51NWsyQV25R3eJo_=YfpnXsh1G1ecRVDYc3w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 05, 2013 at 06:54:49PM -0500, Adrien Vergé wrote:
> > Well, these patches were incorrect, so that's not really a valid
> > question :)
> 
> Should I correct the pid size and send them again?

I'm not the ARM maintainer, so I can't say if I would reject them or
not.

And I don't know if you can fix up the pid issue due to namespaces, how
are you going to specify the namespace of the pid you are interested in?

Oh, and someone should fix up the sysfs files no matter what, they
shouldn't be using "raw" kobjects, but that's not your issue.  I can
send a patch to do that after your additions go in if needed.

thanks,

greg k-h
