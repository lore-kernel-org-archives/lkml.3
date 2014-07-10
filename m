Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750918AbaGJFRc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 01:17:32 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:64559 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbaGJFRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 01:17:31 -0400
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <CAKohpon0KkW+GqTGriioXCRLet0wBzT-7=+_VUBczJtfgTgJqQ@mail.gmail.com>
References: <2CC2A0A4A178534D93D5159BF3BCB661A17A3E48F2@EAPEX1MAIL1.st.com>
	<CAOesGMiu_azMYt3L5OgZSFRgrJQvXvkvSOtr0eLam22CQ5SwuA@mail.gmail.com>
	<CAKohpon0KkW+GqTGriioXCRLet0wBzT-7=+_VUBczJtfgTgJqQ@mail.gmail.com>
Date: Wed, 9 Jul 2014 22:17:30 -0700
Message-ID: <CAOesGMjdAYoFLsqCNMUp7_KbiT8xKn6nkUxX=4V7wojsMp_-2Q@mail.gmail.com>
Subject: Re: [GIT PULL] ARM: SPEAr1310 PCIe updates
From: Olof Johansson <olof@lixom.net>
To: Viresh Kumar <viresh.kumar@linaro.org>
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

On Wed, Jul 9, 2014 at 5:18 PM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On 9 July 2014 23:39, Olof Johansson <olof@lixom.net> wrote:
>> * Why are you sending a pull request for a repo that is not yours?
>
> Because Mohit/Pratyush were facing some issues in pushing patches
> to the SPEAr public git repo. And so I tried to help them out publicly
> and nobody objected then:
>
> https://lkml.org/lkml/2014/7/8/10

This is completely done wrong on so many levels.

I am not going to merge code from someone who doesn't have the basic
skills down when there's already a maintainer for the platform.
Luckily, you can deal with it -- be it coaching the ST employees on
how to work with the community the right way, or doing the work
yourself to send the code up. Probably a combination in this case.

>> * Why is Viresh the git committer but hasn't signed off on the patches?
>
> I didn't sign-off because I haven't even looked closed at many of the
> patches around PCI and Acked whatever I could understand.

Thanks, good to know that the series hasn't been fully reviewed. That
makes me even more hesitant to apply it at the moment, given all the
other issues around it.

> But yeah, this committer thing is what I missed. Because of that I might
> be required to signoff it.

Anyone touching the patch, forwarding it or applying it needs to sign
off. It's quite simple, and well documented.

>> Are you sharing accounts on kernel.org? (Adding kernel.org admin on cc
>> just in case).
>
> Obviously not. I am alone the user of this account.

Good.


-Olof
