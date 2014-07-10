Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825AbaGJASe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 20:18:34 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:41427 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756697AbaGJASc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 20:18:32 -0400
MIME-Version: 1.0
In-Reply-To: <CAOesGMiu_azMYt3L5OgZSFRgrJQvXvkvSOtr0eLam22CQ5SwuA@mail.gmail.com>
References: <2CC2A0A4A178534D93D5159BF3BCB661A17A3E48F2@EAPEX1MAIL1.st.com>
	<CAOesGMiu_azMYt3L5OgZSFRgrJQvXvkvSOtr0eLam22CQ5SwuA@mail.gmail.com>
Date: Thu, 10 Jul 2014 05:48:31 +0530
Message-ID: <CAKohpon0KkW+GqTGriioXCRLet0wBzT-7=+_VUBczJtfgTgJqQ@mail.gmail.com>
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

On 9 July 2014 23:39, Olof Johansson <olof@lixom.net> wrote:
> * Why are you sending a pull request for a repo that is not yours?

Because Mohit/Pratyush were facing some issues in pushing patches
to the SPEAr public git repo. And so I tried to help them out publicly
and nobody objected then:

https://lkml.org/lkml/2014/7/8/10

> * Why is Viresh the git committer but hasn't signed off on the patches?

I didn't sign-off because I haven't even looked closed at many of the
patches around PCI and Acked whatever I could understand.

But yeah, this committer thing is what I missed. Because of that I might
be required to signoff it.

> Are you sharing accounts on kernel.org? (Adding kernel.org admin on cc
> just in case).

Obviously not. I am alone the user of this account.
