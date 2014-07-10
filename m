Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751392AbaGJFYH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 01:24:07 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:55346 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281AbaGJFYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 01:24:05 -0400
MIME-Version: 1.0
In-Reply-To: <CAOesGMjdAYoFLsqCNMUp7_KbiT8xKn6nkUxX=4V7wojsMp_-2Q@mail.gmail.com>
References: <2CC2A0A4A178534D93D5159BF3BCB661A17A3E48F2@EAPEX1MAIL1.st.com>
	<CAOesGMiu_azMYt3L5OgZSFRgrJQvXvkvSOtr0eLam22CQ5SwuA@mail.gmail.com>
	<CAKohpon0KkW+GqTGriioXCRLet0wBzT-7=+_VUBczJtfgTgJqQ@mail.gmail.com>
	<CAOesGMjdAYoFLsqCNMUp7_KbiT8xKn6nkUxX=4V7wojsMp_-2Q@mail.gmail.com>
Date: Thu, 10 Jul 2014 10:54:03 +0530
Message-ID: <CAKohpom79td__V9r68YmOTS_Ws4PKXDAaHLhYeLZcAcHRsjYig@mail.gmail.com>
Subject: Re: [GIT PULL] ARM: SPEAr1310 PCIe updates
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Olof Johansson <olof@lixom.net>
Cc: Mohit KUMAR DCG <Mohit.KUMAR@st.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Pratyush ANAND <pratyush.anand@st.com>,
        "'Bjorn Helgaas' (bhelgaas@google.com)" <bhelgaas@google.com>,
        spear-devel <spear-devel@list.st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Mark Nicholson <mark@nicholnet.com>,
        "FTPAdmin Kernel.org" <ftpadmin@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 July 2014 10:47, Olof Johansson <olof@lixom.net> wrote:
>> I didn't sign-off because I haven't even looked closed at many of the
>> patches around PCI and Acked whatever I could understand.
>
> Thanks, good to know that the series hasn't been fully reviewed. That
> makes me even more hesitant to apply it at the moment, given all the
> other issues around it.

Its not that the series hasn't been fully reviewed, it is.

Arnd has reviewed and Acked the complete series. I have Acked SPEAr
specific parts and Bjorn have Acked PCI specific stuff.

>> But yeah, this committer thing is what I missed. Because of that I might
>> be required to signoff it.
>
> Anyone touching the patch, forwarding it or applying it needs to sign
> off. It's quite simple, and well documented.

Yeah, my mistake. Accepted.
