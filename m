Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836AbaJCOZO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 10:25:14 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:64003 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093AbaJCOZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 10:25:11 -0400
MIME-Version: 1.0
In-Reply-To: <20141003141548.GG8971@agordeev.usersys.redhat.com>
References: <20141003132522.GA32634@wfg-t540p.sh.intel.com> <20141003141548.GG8971@agordeev.usersys.redhat.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 3 Oct 2014 08:24:50 -0600
Message-ID: <CAErSpo5ha38Kq=AMJrFiKjoZGkLkAX2vccm4N9ftH4LkifB9_A@mail.gmail.com>
Subject: Re: [PCI/MSI] WARNING: CPU: 0 PID: 1 at drivers/pci/msi.c:1034 pci_enable_msi_range+0x2c1/0x2f0()
To: Alexander Gordeev <agordeev@redhat.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>, Dave Hansen <dave.hansen@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, LKP <lkp@01.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 3, 2014 at 8:15 AM, Alexander Gordeev <agordeev@redhat.com> wrote:
> On Fri, Oct 03, 2014 at 09:25:22PM +0800, Fengguang Wu wrote:
>> Hi Alexander,
>>
>> FYI, we noticed the below changes on
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git pci/msi
>> commit 4ab2ee7c77875669230a797a3ed2228990f82545 ("PCI/MSI: Rename pci_msi_check_device() to pci_msi_supported()")
>
> This commit was fixed and rebased and has different hash now:
>
> a06cd74cefe754341f747ddc4cf7b0058fa9bff8

Yep, I think this problem has been fixed already.

Bjorn
