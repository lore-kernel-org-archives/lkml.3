Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330AbaA3OVn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 09:21:43 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:62611 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752983AbaA3OVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 09:21:40 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Tanmay Inamdar <tinamdar@apm.com>
Subject: Re: [RFC PATCH V3 0/4] APM X-Gene PCIe controller
Date: Thu, 30 Jan 2014 15:21:11 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Dann Frazier <dann.frazier@canonical.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Rob Landley <rob@landley.net>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm" <linux-arm-kernel@lists.infradead.org>,
        linux-doc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        patches <patches@apm.com>, Jon Masters <jcm@redhat.com>
References: <1390599168-13150-1-git-send-email-tinamdar@apm.com> <CAErSpo7Dfd4NJBEDuVe1VCvZObFq1YvV2x77S60Z4-CZq89QJw@mail.gmail.com> <CACoXjc=LSrLK=kd9GJoHWJovVDC+TfH2bZO-2Ht9jMoBrL9eag@mail.gmail.com>
In-Reply-To: <CACoXjc=LSrLK=kd9GJoHWJovVDC+TfH2bZO-2Ht9jMoBrL9eag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201401301521.11665.arnd@arndb.de>
X-Provags-ID: V02:K0:t/Re1M/tM0Pf4nfz94RPZx4JqU4YfKI0OcbvvbVZeTh
 oLCFb+lVEgzz3fGt8hepx8ywsB4Oakt8yh645dfX/Tot7DeI6P
 DR1ZWTq4dVSN//k6yMS85DpEuIgbV+mgv94r5aVJPBXdzrfQzr
 pTF9kGlKLvOx/K1/R0+Ua5RGFvIiL1BaxaKTsQUW/fyFo3VmLz
 gOOwDI2dPUlYEQc7v6UfJgHLMKpkLxr/Bf8CXut0RjgmnPxfRT
 zozUgP5AGCSI+OSbXf4Zt4sZlGsiuQuzxwxjSg85E2ez0zU5If
 aDmtYlaeQbzpsFvySexn9tfUpywIQoMlAlzx4/+fyEouEEF3qz
 76JHtsuBQiH6J0iOLCsChPFdLyoQv8l9gRlS7F3/X
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 30 January 2014, Tanmay Inamdar wrote:
> >
> > When you repost, please make sure you fix whatever problem is
> > preventing your email from appearing on the vger mailing lists.  I
> > won't apply things that haven't appeared on the linux-pci list,
> > because that list is the opportunity for other people to review them.
> >
> You are absolutely right. If the patches are not reaching mailing
> list, they should not appear on archive list as well. However I am
> seeing my patches recorded on archives. So I am not sure if they are
> actually getting dropped on linux-pci or any other mailing list.
> 
> http://www.spinics.net/lists/linux-pci/msg28198.html
> http://article.gmane.org/gmane.linux.kernel.pci/28442/match=tanmay+inamdar

Very strange. I can also confirm that I received the patches through
the linux-arm-kernel and devicetree mailing lists without problems.

	Arnd
