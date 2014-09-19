Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243AbaISFPj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 01:15:39 -0400
Received: from mail-ig0-f174.google.com ([209.85.213.174]:57575 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749AbaISFPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 01:15:37 -0400
Date: Thu, 18 Sep 2014 23:15:34 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Mohit KUMAR DCG <Mohit.KUMAR@st.com>
Cc: Fabio Estevam <festevam@gmail.com>,
        "matwey@sai.msu.ru" <matwey@sai.msu.ru>,
        Jingoo Han <jg1.han@samsung.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "matwey.kornilov@gmail.com" <matwey.kornilov@gmail.com>
Subject: Re: [PATCH] Export functions from pcie-designware
Message-ID: <20140919051534.GA21128@google.com>
References: <1409401476-5002-1-git-send-email-matwey@sai.msu.ru>
 <CAOMZO5DzNo3Y6=R4mA=h0+RjWoM6UBCqXxqeEqUM4iu5RjrBEA@mail.gmail.com>
 <20140916233841.GJ5050@google.com>
 <2CC2A0A4A178534D93D5159BF3BCB661ABCD7BCF19@EAPEX1MAIL1.st.com>
 <CAErSpo55KbMR9hPR_MssnDTCdN731QP_u_xVbYw1c8iWWGvBVA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo55KbMR9hPR_MssnDTCdN731QP_u_xVbYw1c8iWWGvBVA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2014 at 10:11:22PM -0700, Bjorn Helgaas wrote:
> On Tue, Sep 16, 2014 at 9:54 PM, Mohit KUMAR DCG <Mohit.KUMAR@st.com> wrote:
> > Hello Bjorn,
> >
> >> -----Original Message-----
> >> From: Bjorn Helgaas [mailto:bhelgaas@google.com]
> >> Sent: Wednesday, September 17, 2014 5:09 AM
> >> To: Fabio Estevam
> >> Cc: matwey@sai.msu.ru; Mohit KUMAR DCG; Jingoo Han; linux-
> >> pci@vger.kernel.org; linux-kernel; matwey.kornilov@gmail.com
> >> Subject: Re: [PATCH] Export functions from pcie-designware
> >>
> >> On Sat, Aug 30, 2014 at 10:07:30AM -0300, Fabio Estevam wrote:
> >> > On Sat, Aug 30, 2014 at 9:24 AM,  <matwey@sai.msu.ru> wrote:
> >> > > From: "Matwey V. Kornilov" <matwey@sai.msu.ru>
> >> > >
> >> > > pcie-spear13xx when built as module requires the functions from pcie-
> >> designware.
> >> > > Export them properly.
> >>
> >> I don't know how valuable pcie-spear13xx as a module is.  No other host
> >> drivers are supported as a module.  Maybe we should just change pcie-
> >> spear13xx from tristate to bool?
> >>
> > -  Sachin's patch is already doing this:
> > http://www.spinics.net/lists/linux-pci/msg33665.html
> >
> > You acknowledge it to apply for v3.17 but somehow it has been left out.
> 
> Oops, sorry!  I was pretty sure I remembered a patch like this, but
> somehow I deleted the branch before it got fully merged.  Anyway, I
> re-did it.  Thanks for the reminder.

Actually, I *had* already merged it, and it's been in Linus' tree since
2014-09-03 15:45:48 (GMT) and appeared in v3.17-rc4:

https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/drivers/pci/host/Kconfig?id=f16c15a0e0ea

Or am I still missing something?

Bjorn
