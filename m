Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174Ab3C1MH1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 08:07:27 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:15869 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589Ab3C1MHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 08:07:25 -0400
X-Greylist: delayed 3516 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Mar 2013 08:07:25 EDT
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19q5ycdxf02YxnGV+Ac/VftmOpDyNlRDmk=
Date: Thu, 28 Mar 2013 07:08:41 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "Woodhouse, David" <david.woodhouse@intel.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] pinctrl: mvebu: prevent walking off the end of
 group array
Message-ID: <20130328110841.GT13280@titan.lakedaemon.net>
References: <1363196884-20193-1-git-send-email-jason@lakedaemon.net>
 <1363434272-23172-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <CACRpkdb-CdmzszyixBLGdZjXJXzef26u0qN9xWcrYa3JbAD3Ow@mail.gmail.com>
 <1364422304.14860.9.camel@i7.infradead.org>
 <CACRpkdZvz0f-kwS1N=wc438THUuU9_g0VFoy7OYUAiaL8hkBNw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdZvz0f-kwS1N=wc438THUuU9_g0VFoy7OYUAiaL8hkBNw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27, 2013 at 11:34:53PM +0100, Linus Walleij wrote:
> On Wed, Mar 27, 2013 at 11:11 PM, Woodhouse, David
> <david.woodhouse@intel.com> wrote:
> > On Wed, 2013-03-27 at 23:06 +0100, Linus Walleij wrote:
> >> Is it so critical that it needs to be tagged for stable as well
> >> then tell me.
> >>
> >> If it's non-critical enough to live on for -next then tell me.
> >
> > I don't think it's critical. It'll probably never trigger in practice.
> 
> Thanks, moving it to for-next then...

Thanks, Linus.

thx,

Jason.
