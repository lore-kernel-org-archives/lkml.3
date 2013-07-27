Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752360Ab3G0QKS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 12:10:18 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:44254 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276Ab3G0QKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 12:10:15 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQX7g_L=u_EGGUgbHZ4z_u1feu47UeuvDkaK7eXChyHGGg@mail.gmail.com>
References: <51F23D0F.7090909@oracle.com> <20130726173956.GA14078@google.com> <CAE9FiQX7g_L=u_EGGUgbHZ4z_u1feu47UeuvDkaK7eXChyHGGg@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Sat, 27 Jul 2013 10:09:54 -0600
Message-ID: <CAErSpo6ohVm=YfxY_Oci1byjPhr3t0hZu38HGRRfN+92eD1NJg@mail.gmail.com>
Subject: Re: [PATCH] x86/PCI: MMCONFIG: cleanup and add address warning to pci_mmconfig_insert
To: Yinghai Lu <yinghai@kernel.org>
Cc: ethan zhao <ethan.zhao@oracle.com>,
        "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ethan Zhao <ethan.kernel@gmail.com>, Jiang Liu <jiang.liu@huawei.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 27, 2013 at 8:27 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Fri, Jul 26, 2013 at 10:39 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:

>>     [bhelgaas: changelog, drop printk]
>>     Signed-off-by: ethan.zhao <ethan.zhao@oracle.com>
>>     Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
>>     Acked-by: Yinghai Lu <yinghai@kerne.org>
>
> looks like I had typo in ack. please update to
>
> Acked-by: Yinghai Lu <yinghai@kernel.org>

Done, thanks, sorry I didn't notice that :)
