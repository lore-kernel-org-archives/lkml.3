Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753781Ab3CQANv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 20:13:51 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:59225 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105Ab3CQANt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 20:13:49 -0400
MIME-Version: 1.0
In-Reply-To: <CAL-B5D0JOTBTRhh-i=DkiUjSsid1v408DE5nj_R2qvaHDtEQ=g@mail.gmail.com>
References: <1362666556-10036-1-git-send-email-yxlraid@gmail.com>
	<CAErSpo7feQK7pXD=moA_hf=Y-j82oZZKwfDNzfo2Ea7i9VPxtA@mail.gmail.com>
	<F766E4F80769BD478052FB6533FA745D25F436856A@SC-VEXCH4.marvell.com>
	<CAErSpo6RDC+QyyN4kwt7-kU5d8b1iu+zCQZTGZPxCJU2UicTCA@mail.gmail.com>
	<F766E4F80769BD478052FB6533FA745D25F436861C@SC-VEXCH4.marvell.com>
	<CAErSpo6ascpN=bBUUzkk5W3-Wee_1ZztAyTwnKd-tq=L_9Q3mw@mail.gmail.com>
	<F766E4F80769BD478052FB6533FA745D25F440A477@SC-VEXCH4.marvell.com>
	<CAL-B5D1=zqB_9sWL9A_GgY6OgGdw18qxBHbgj_YG2bj0VGDh4Q@mail.gmail.com>
	<F766E4F80769BD478052FB6533FA745D25F440A64D@SC-VEXCH4.marvell.com>
	<CAL-B5D3od8zhtYguH36r1XmHw_rvg0Tcdgv8ewYrgHFsJ2Sefw@mail.gmail.com>
	<F766E4F80769BD478052FB6533FA745D25F440A9C6@SC-VEXCH4.marvell.com>
	<CAErSpo7ufeQK1e=HSTYCNie7yfPouYE4-ot9dUX5r-upBtVt=A@mail.gmail.com>
	<F766E4F80769BD478052FB6533FA745D25F440ACE9@SC-VEXCH4.marvell.com>
	<CAL-B5D0JOTBTRhh-i=DkiUjSsid1v408DE5nj_R2qvaHDtEQ=g@mail.gmail.com>
Date: Sat, 16 Mar 2013 18:13:48 -0600
Message-ID: <CAL-B5D15UP0-z+4whBVxsbHm6_43DEK5+BOr=PZYsc-DNB7VrQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] PCI: fix system hang issue of Marvell SATA host controller
From: Myron Stowe <myron.stowe@gmail.com>
To: Xiangliang Yu <yuxiangl@marvell.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, yxlraid <yxlraid@gmail.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 14, 2013 at 9:03 AM, Myron Stowe <myron.stowe@gmail.com> wrote:
> On Wed, Mar 13, 2013 at 3:40 AM, Xiangliang Yu <yuxiangl@marvell.com> wrote:
>> Hi, Bjorn
>>
>>> >> > Now, the situation is like this:
>>> >> > I captured the PCIE trace with analyzer and found that 1st BE is 0x1111
>>> >> > when
>>> >> > accessing IO port space. But 9125 spec has some limitation, and the BE
>>> >> > must
>>> >> > be
>>> >> > 0x0100, to access the 2nd byte only. So, the chip will go to bad.
>>> >>
>>> >> Great, this is new, interesting, data.  Is the 9125 spec publicly
>>> >> accessible and/or could you elaborate on the "some limitation"
>>> >> comment?
>>> > 9125 spec is publicly accessible.
>> If you can't see the pic, please open the attachment. Thanks!
>
> Neither Bjorn nor myself could see the pic (from the previous thread
> or this thread's attachment).
>
>>
>>

Just an FYI that I proposed a different tact at
https://lkml.org/lkml/2013/3/16/168.  For those following this thread
you may want to start following that thread also.
