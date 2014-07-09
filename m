Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932271AbaGISJ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 14:09:29 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:40728 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755152AbaGISJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 14:09:09 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:157d:8cce:4220:32bc:b297]
In-Reply-To: <2CC2A0A4A178534D93D5159BF3BCB661A17A3E48F2@EAPEX1MAIL1.st.com>
References: <2CC2A0A4A178534D93D5159BF3BCB661A17A3E48F2@EAPEX1MAIL1.st.com>
Date: Wed, 9 Jul 2014 11:09:08 -0700
Message-ID: <CAOesGMiu_azMYt3L5OgZSFRgrJQvXvkvSOtr0eLam22CQ5SwuA@mail.gmail.com>
Subject: Re: [GIT PULL] ARM: SPEAr1310 PCIe updates
From: Olof Johansson <olof@lixom.net>
To: Mohit KUMAR DCG <Mohit.KUMAR@st.com>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Pratyush ANAND <pratyush.anand@st.com>,
        "'Bjorn Helgaas' (bhelgaas@google.com)" <bhelgaas@google.com>,
        spear-devel <spear-devel@list.st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Mark Nicholson <mark@nicholnet.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "FTPAdmin Kernel.org" <ftpadmin@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,



On Tue, Jul 8, 2014 at 10:48 PM, Mohit KUMAR DCG <Mohit.KUMAR@st.com> wrote:
> Hello Olof,
>
> Please pull PCIe updates for ST's SPEAr1310 SoC.
>
> Last version of posted V8 patches have been Acked-by respective maintainers.
> https://lkml.org/lkml/2014/4/15/260
>
> Apart from arch/arm/ changes, it also contains patches for drivers/{pci|phy}.
> Bjorn advised to get complete series via arm-soc tree.
> http://www.spinics.net/lists/linux-pci/msg30271.html
>
>  Regards
>  Mohit
>
> The following changes since commit 4c834452aad01531db949414f94f817a86348d59:
>   Linus Torvalds (1):
>         Linux 3.16-rc3
>
> are available in the git repository at:
>
>   https://git.kernel.org/pub/scm/linux/kernel/git/vireshk/linux.git spear/pcie-support-v8
>
> Mohit Kumar (1):
>       SPEAr13xx: defconfig: Update
>
> Pratyush Anand (8):
>       clk: SPEAr13XX: Fix pcie clock name
>       SPEAr13XX: Fix static mapping table
>       phy: SPEAr1310/40-miphy: Add binding information
>       SPEAr: misc: Add binding information
>       phy: SPEAr1310/40-miphy: Add phy driver for PCIe and SATA
>       SPEAr13XX: Add binding information for PCIe controller
>       SPEAr13XX: dts: Add PCIe node information
>       pcie: SPEAr13xx: Add designware wrapper support

There are so many things wrong with this pull request.

* Why is this not coming from the spear maintainer that knows how to
look at patches and deal with these things?
* Why have you separated out the PCIe node info, but not the phy DTS
updates in separate patches?
* Why are you sending a pull request for a repo that is not yours?
* Why is Viresh the git committer but hasn't signed off on the patches?

Are you sharing accounts on kernel.org? (Adding kernel.org admin on cc
just in case).

I'm not going to touch this pull request until the above has been
sorted out and explained.


-Olof
