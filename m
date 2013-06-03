Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752158Ab3FCHeP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 03:34:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6221 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751146Ab3FCHeK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 03:34:10 -0400
Date: Mon, 3 Jun 2013 09:35:33 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Mike Qiu <qiudayu@linux.vnet.ibm.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] irqdomain: Do not reuse existing mappings
Message-ID: <20130603073532.GA30878@dhcp-26-207.brq.redhat.com>
References: <20130531125910.GA1454@dhcp-26-207.brq.redhat.com>
 <20130531223024.AB12F3E08FE@localhost>
 <20130602115634.GA15561@dhcp-26-207.brq.redhat.com>
 <CACxGe6uWZxb_ZeSoYDOOaA9+DqSCDd+zM8SQfpKkeiCmHoUNkA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACxGe6uWZxb_ZeSoYDOOaA9+DqSCDd+zM8SQfpKkeiCmHoUNkA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 02, 2013 at 05:52:21PM +0100, Grant Likely wrote:
> On Sun, Jun 2, 2013 at 12:56 PM, Alexander Gordeev <agordeev@redhat.com> wrote:
> > On Fri, May 31, 2013 at 11:30:24PM +0100, Grant Likely wrote:
> >> On Fri, 31 May 2013 14:59:11 +0200, Alexander Gordeev <agordeev@redhat.com> wrote:
> >> What exactly is the problem that you're trying to solve with this patch?
> >> It's not clear from the description.
> >
> > Hi Grant,
> >
> > Thanks for the clarification!
> >
> > No particular problem - I just was confused with this particular behaviour
> > and failed to put RFC in subject line. Sorry for that.
> 
> Hi Alexander,
> 
> So there isn't an actual bug or problem that you're trying to solve?
> If you've got a problem on a real system then I'd like to know about
> it.

Well, there is a QLogic HBA chip which does not support MSI-X, but does
support multiple MSIs (I suspect there are few of them in fact). The change
I posted is part of the update (multiple MSIs enablement + qla2xxx driver
change), but the whole series is not tested and frankly, I am not sure I
ever post it. So please nevermind ;)

> g.

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
