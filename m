Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751360AbaIQFLo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 01:11:44 -0400
Received: from mail-qg0-f44.google.com ([209.85.192.44]:51372 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbaIQFLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 01:11:43 -0400
MIME-Version: 1.0
In-Reply-To: <2CC2A0A4A178534D93D5159BF3BCB661ABCD7BCF19@EAPEX1MAIL1.st.com>
References: <1409401476-5002-1-git-send-email-matwey@sai.msu.ru>
 <CAOMZO5DzNo3Y6=R4mA=h0+RjWoM6UBCqXxqeEqUM4iu5RjrBEA@mail.gmail.com>
 <20140916233841.GJ5050@google.com> <2CC2A0A4A178534D93D5159BF3BCB661ABCD7BCF19@EAPEX1MAIL1.st.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 16 Sep 2014 22:11:22 -0700
Message-ID: <CAErSpo55KbMR9hPR_MssnDTCdN731QP_u_xVbYw1c8iWWGvBVA@mail.gmail.com>
Subject: Re: [PATCH] Export functions from pcie-designware
To: Mohit KUMAR DCG <Mohit.KUMAR@st.com>
Cc: Fabio Estevam <festevam@gmail.com>,
        "matwey@sai.msu.ru" <matwey@sai.msu.ru>,
        Jingoo Han <jg1.han@samsung.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "matwey.kornilov@gmail.com" <matwey.kornilov@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2014 at 9:54 PM, Mohit KUMAR DCG <Mohit.KUMAR@st.com> wrote:
> Hello Bjorn,
>
>> -----Original Message-----
>> From: Bjorn Helgaas [mailto:bhelgaas@google.com]
>> Sent: Wednesday, September 17, 2014 5:09 AM
>> To: Fabio Estevam
>> Cc: matwey@sai.msu.ru; Mohit KUMAR DCG; Jingoo Han; linux-
>> pci@vger.kernel.org; linux-kernel; matwey.kornilov@gmail.com
>> Subject: Re: [PATCH] Export functions from pcie-designware
>>
>> On Sat, Aug 30, 2014 at 10:07:30AM -0300, Fabio Estevam wrote:
>> > On Sat, Aug 30, 2014 at 9:24 AM,  <matwey@sai.msu.ru> wrote:
>> > > From: "Matwey V. Kornilov" <matwey@sai.msu.ru>
>> > >
>> > > pcie-spear13xx when built as module requires the functions from pcie-
>> designware.
>> > > Export them properly.
>>
>> I don't know how valuable pcie-spear13xx as a module is.  No other host
>> drivers are supported as a module.  Maybe we should just change pcie-
>> spear13xx from tristate to bool?
>>
> -  Sachin's patch is already doing this:
> http://www.spinics.net/lists/linux-pci/msg33665.html
>
> You acknowledge it to apply for v3.17 but somehow it has been left out.

Oops, sorry!  I was pretty sure I remembered a patch like this, but
somehow I deleted the branch before it got fully merged.  Anyway, I
re-did it.  Thanks for the reminder.

Bjorn
