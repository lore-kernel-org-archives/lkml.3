Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751656Ab3LFG3V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 01:29:21 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:60691 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105Ab3LFG3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 01:29:18 -0500
MIME-Version: 1.0
In-Reply-To: <1992931.Zv6xBcN8V4@vostro.rjw.lan>
References: <1385429290-25397-1-git-send-email-yinghai@kernel.org>
	<33026900.FbCAopDPFz@vostro.rjw.lan>
	<CAErSpo6edmz5nkSYogbYk1FFYsCCwNV_-rir2jGP2JBnvOx+iw@mail.gmail.com>
	<1992931.Zv6xBcN8V4@vostro.rjw.lan>
Date: Thu, 5 Dec 2013 22:29:17 -0800
X-Google-Sender-Auth: 9CwQeh9hgKjdX9UK02mQzi_7UMY
Message-ID: <CAE9FiQWnvZwfJ+qoazMQP11bh_VuFDctGf0zcBhEfADRWH_ocg@mail.gmail.com>
Subject: Re: [PATCH v2 04/10] PCI: Destroy pci dev only once
From: Yinghai Lu <yinghai@kernel.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Guo Chao <yan@linux.vnet.ibm.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Myron Stowe <myron.stowe@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 5, 2013 at 5:21 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
>>
>> The use-after-free problems *sound* like a reference counting issue.
>> Yinghai's patch [1] should fix some of this; how much is left after
>> that?
>>
>> [1] http://lkml.kernel.org/r/1385851238-21085-4-git-send-email-yinghai@kernel.org
>
> Hmm, no.  Do you mean https://patchwork.kernel.org/patch/3261171/ ?

should be

https://patchwork.kernel.org/patch/3261001/
[v3,03/12] PCI: Move resources and bus_list releasing to pci_release_dev

move down list_del(&pci_dev->bus_list).

Yinghai
