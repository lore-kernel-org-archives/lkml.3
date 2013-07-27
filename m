Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871Ab3G0XuZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 19:50:25 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:45512 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611Ab3G0XuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 19:50:24 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo6ohVm=YfxY_Oci1byjPhr3t0hZu38HGRRfN+92eD1NJg@mail.gmail.com>
References: <51F23D0F.7090909@oracle.com>
	<20130726173956.GA14078@google.com>
	<CAE9FiQX7g_L=u_EGGUgbHZ4z_u1feu47UeuvDkaK7eXChyHGGg@mail.gmail.com>
	<CAErSpo6ohVm=YfxY_Oci1byjPhr3t0hZu38HGRRfN+92eD1NJg@mail.gmail.com>
Date: Sun, 28 Jul 2013 07:50:23 +0800
Message-ID: <CABawtvPjUMTEUVO7ET6=pjeH55eYmWfj3pD-Y4UpdqO2FN=Oig@mail.gmail.com>
Subject: Re: [PATCH] x86/PCI: MMCONFIG: cleanup and add address warning to pci_mmconfig_insert
From: Ethan Zhao <ethan.kernel@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Yinghai Lu <yinghai@kernel.org>, ethan zhao <ethan.zhao@oracle.com>,
        "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jiang Liu <jiang.liu@huawei.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seems there are code style issues etc after I pasted it in my mail client.
I will correct it and resend v2.

Thanks.

On Sun, Jul 28, 2013 at 12:09 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Sat, Jul 27, 2013 at 8:27 AM, Yinghai Lu <yinghai@kernel.org> wrote:
>> On Fri, Jul 26, 2013 at 10:39 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>
>>>     [bhelgaas: changelog, drop printk]
>>>     Signed-off-by: ethan.zhao <ethan.zhao@oracle.com>
>>>     Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
>>>     Acked-by: Yinghai Lu <yinghai@kerne.org>
>>
>> looks like I had typo in ack. please update to
>>
>> Acked-by: Yinghai Lu <yinghai@kernel.org>
>
> Done, thanks, sorry I didn't notice that :)
