Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751281AbaIXEeH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 00:34:07 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:43354 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750767AbaIXEeE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 00:34:04 -0400
From: Mohit KUMAR DCG <Mohit.KUMAR@st.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Fabio Estevam <festevam@gmail.com>
Cc: Fabio Estevam <festevam@gmail.com>,
        "matwey@sai.msu.ru" <matwey@sai.msu.ru>,
        Jingoo Han <jg1.han@samsung.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "matwey.kornilov@gmail.com" <matwey.kornilov@gmail.com>
Date: Wed, 24 Sep 2014 12:33:36 +0800
Subject: RE: [PATCH] Export functions from pcie-designware
Thread-Topic: [PATCH] Export functions from pcie-designware
Thread-Index: Ac/TyMMrQ7nax9fgTfmZNHN38pxY9AD5ndTg
Message-ID: <2CC2A0A4A178534D93D5159BF3BCB661ABCDBA8F01@EAPEX1MAIL1.st.com>
References: <1409401476-5002-1-git-send-email-matwey@sai.msu.ru>
 <CAOMZO5DzNo3Y6=R4mA=h0+RjWoM6UBCqXxqeEqUM4iu5RjrBEA@mail.gmail.com>
 <20140916233841.GJ5050@google.com>
 <2CC2A0A4A178534D93D5159BF3BCB661ABCD7BCF19@EAPEX1MAIL1.st.com>
 <CAErSpo55KbMR9hPR_MssnDTCdN731QP_u_xVbYw1c8iWWGvBVA@mail.gmail.com>
 <20140919051534.GA21128@google.com>
In-Reply-To: <20140919051534.GA21128@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-09-24_03:2014-09-23,2014-09-24,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Bjorn,

> -----Original Message-----
> From: Bjorn Helgaas [mailto:bhelgaas@google.com]
> Sent: Friday, September 19, 2014 10:46 AM
> To: Mohit KUMAR DCG
> Cc: Fabio Estevam; matwey@sai.msu.ru; Jingoo Han; linux-
> pci@vger.kernel.org; linux-kernel; matwey.kornilov@gmail.com
> Subject: Re: [PATCH] Export functions from pcie-designware
> 
> On Tue, Sep 16, 2014 at 10:11:22PM -0700, Bjorn Helgaas wrote:
> > On Tue, Sep 16, 2014 at 9:54 PM, Mohit KUMAR DCG
> <Mohit.KUMAR@st.com> wrote:
> > > Hello Bjorn,
> > >
> > >> -----Original Message-----
> > >> From: Bjorn Helgaas [mailto:bhelgaas@google.com]
> > >> Sent: Wednesday, September 17, 2014 5:09 AM
> > >> To: Fabio Estevam
> > >> Cc: matwey@sai.msu.ru; Mohit KUMAR DCG; Jingoo Han; linux-
> > >> pci@vger.kernel.org; linux-kernel; matwey.kornilov@gmail.com
> > >> Subject: Re: [PATCH] Export functions from pcie-designware
> > >>
> > >> On Sat, Aug 30, 2014 at 10:07:30AM -0300, Fabio Estevam wrote:
> > >> > On Sat, Aug 30, 2014 at 9:24 AM,  <matwey@sai.msu.ru> wrote:
> > >> > > From: "Matwey V. Kornilov" <matwey@sai.msu.ru>
> > >> > >
> > >> > > pcie-spear13xx when built as module requires the functions from
> > >> > > pcie-
> > >> designware.
> > >> > > Export them properly.
> > >>
> > >> I don't know how valuable pcie-spear13xx as a module is.  No other
> > >> host drivers are supported as a module.  Maybe we should just
> > >> change pcie- spear13xx from tristate to bool?
> > >>
> > > -  Sachin's patch is already doing this:
> > > http://www.spinics.net/lists/linux-pci/msg33665.html
> > >
> > > You acknowledge it to apply for v3.17 but somehow it has been left out.
> >
> > Oops, sorry!  I was pretty sure I remembered a patch like this, but
> > somehow I deleted the branch before it got fully merged.  Anyway, I
> > re-did it.  Thanks for the reminder.
> 
> Actually, I *had* already merged it, and it's been in Linus' tree since
> 2014-09-03 15:45:48 (GMT) and appeared in v3.17-rc4:
> 
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/drivers
> /pci/host/Kconfig?id=f16c15a0e0ea
> 
- yes, its been merged. I think Fabio was working with v3.17-rc2 or earlier.

Fabio,
Pls let us know if you still have any concern after  merging of this patch.

Thanks
Mohit

> Or am I still missing something?
> 
> Bjorn
