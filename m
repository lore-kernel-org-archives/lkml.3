Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752426AbaA3AkY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 19:40:24 -0500
Received: from exprod5og113.obsmtp.com ([64.18.0.26]:47513 "HELO
	exprod5og113.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751744AbaA3AkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 19:40:21 -0500
MIME-Version: 1.0
In-Reply-To: <CAErSpo7Dfd4NJBEDuVe1VCvZObFq1YvV2x77S60Z4-CZq89QJw@mail.gmail.com>
References: <1390599168-13150-1-git-send-email-tinamdar@apm.com>
	<CALdTtnsEo74UeYgoQ0DF7=LN074b_0bL0vg6Bxs02B9nDkRTNA@mail.gmail.com>
	<CAErSpo7Dfd4NJBEDuVe1VCvZObFq1YvV2x77S60Z4-CZq89QJw@mail.gmail.com>
Date: Wed, 29 Jan 2014 16:40:18 -0800
Message-ID: <CACoXjc=LSrLK=kd9GJoHWJovVDC+TfH2bZO-2Ht9jMoBrL9eag@mail.gmail.com>
Subject: Re: [RFC PATCH V3 0/4] APM X-Gene PCIe controller
From: Tanmay Inamdar <tinamdar@apm.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Dann Frazier <dann.frazier@canonical.com>, Arnd Bergmann <arnd@arndb.de>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Rob Landley <rob@landley.net>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        linux-doc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        patches <patches@apm.com>, Jon Masters <jcm@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 29, 2014 at 4:18 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Sat, Jan 25, 2014 at 9:09 AM, Dann Frazier
> <dann.frazier@canonical.com> wrote:
>> On Fri, Jan 24, 2014 at 2:32 PM, Tanmay Inamdar <tinamdar@apm.com> wrote:
>>> This patch adds support for AppliedMicro X-Gene PCIe host controller. The
>>> driver is tested on X-Gene platform with different gen1/2/3 PCIe endpoint
>>> cards.
>>>
>>> X-Gene PCIe controller driver has depedency on the pcie arch support for
>>> arm64. The arm64 pcie arch support is not yet part of mainline Linux kernel
>>> and approach for arch support is under discussion with arm64 maintainers.
>>> The reference patch can be found here --> https://lkml.org/lkml/2013/10/23/244
>>
>> The reference patch looks corrupted (pcibios.c has no includes, etc),
>> would you mind reposting?
>
> When you repost, please make sure you fix whatever problem is
> preventing your email from appearing on the vger mailing lists.  I
> won't apply things that haven't appeared on the linux-pci list,
> because that list is the opportunity for other people to review them.
>
You are absolutely right. If the patches are not reaching mailing
list, they should not appear on archive list as well. However I am
seeing my patches recorded on archives. So I am not sure if they are
actually getting dropped on linux-pci or any other mailing list.

http://www.spinics.net/lists/linux-pci/msg28198.html
http://article.gmane.org/gmane.linux.kernel.pci/28442/match=tanmay+inamdar

> Bjorn
