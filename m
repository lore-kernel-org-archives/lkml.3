Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751603Ab3CAXSP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 18:18:15 -0500
Received: from mail-qa0-f44.google.com ([209.85.216.44]:48533 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245Ab3CAXSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 18:18:13 -0500
From: "Justin Piszcz" <jpiszcz@lucidpixels.com>
To: "'Andrew Cooks'" <acooks@gmail.com>
Cc: "'Joerg Roedel'" <joro@8bytes.org>, "'YingChu'" <xjtuychu@hotmail.com>,
        "'Chu Ying'" <gm.ychu@gmail.com>,
        "'Alex Williamson'" <alex.williamson@redhat.com>,
        <bhelgaas@google.com>, "'David Woodhouse'" <dwmw2@infradead.org>,
        "'open list:INTEL IOMMU \(VT-d\)'" <iommu@lists.linux-foundation.org>,
        "'open list'" <linux-kernel@vger.kernel.org>,
        "'open list:PCI SUBSYSTEM'" <linux-pci@vger.kernel.org>
References: <1354533387-4110-1-git-send-email-acooks@gmail.com>	<1355914703-28576-1-git-send-email-acooks@gmail.com>	<1362126373-32318-1-git-send-email-acooks@gmail.com>	<CAO9zADxjoP+R9ccz7vMPmcFvdYwNjErSjaWc_RFkW_FY3+SK=w@mail.gmail.com> <CAJtEV7Zs2BiwJ9jdDeoceh9hiVXvVaSvj=9H+4+vEzhY72AS9g@mail.gmail.com>
In-Reply-To: <CAJtEV7Zs2BiwJ9jdDeoceh9hiVXvVaSvj=9H+4+vEzhY72AS9g@mail.gmail.com>
Subject: RE: [PATCH] Quirk to support Marvell 88SE91xx SATA controllers with Intel IOMMU.
Date: Fri, 1 Mar 2013 18:18:10 -0500
Message-ID: <00b701ce16d3$0aabe0f0$2003a2d0$@lucidpixels.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQIIKZSuL60UU+m8wYLyh6ljrQ5QswLzR3IpAdE8RacCHftIbgMK2uKGl83kzmA=
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



-----Original Message-----
From: Andrew Cooks [mailto:acooks@gmail.com] 
Sent: Friday, March 01, 2013 5:19 PM
To: Justin Piszcz
Cc: Joerg Roedel; YingChu; Chu Ying; Alex Williamson; bhelgaas@google.com;
David Woodhouse; open list:INTEL IOMMU (VT-d); open list; open list:PCI
SUBSYSTEM
Subject: Re: [PATCH] Quirk to support Marvell 88SE91xx SATA controllers with
Intel IOMMU.

On Sat, Mar 2, 2013 at 1:51 AM, Justin Piszcz <jpiszcz@lucidpixels.com>
wrote:
>
>

> Thanks for testing!
No problem.

Against a clean 3.7.10 (from ftp.kernel.org)

# patch -p1 <
../patch/RFC-Fix-Intel-IOMMU-support-for-Marvell-88SE91xx-SATA-controllers..
patch 
patching file drivers/iommu/intel-iommu.c
patching file drivers/pci/quirks.c
Hunk #1 succeeded at 3230 (offset 3 lines).
patching file include/linux/pci.h
# pwd
/usr/src/linux-3.7.10

Full dmesg with the patch applied: (but with IOMMU off)
http://home.comcast.net/~jpiszcz/20130301/dmesg-full.txt

Full dmesg (as much as possible through netconsole with IOMMU on)
http://home.comcast.net/~jpiszcz/20130301/dmesg-iommu-on.txt

Let me know if anything else is needed, thanks.

Justin.


