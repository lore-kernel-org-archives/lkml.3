Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757558Ab3KYTsp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 14:48:45 -0500
Received: from mail-oa0-f51.google.com ([209.85.219.51]:63803 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755289Ab3KYTsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 14:48:40 -0500
MIME-Version: 1.0
In-Reply-To: <1890016.dnpTzZzgDl@vostro.rjw.lan>
References: <1384866598-19716-1-git-send-email-mika.westerberg@linux.intel.com>
	<CAE9FiQXfhK9k8j0jQ_aHt=+frrhcHZH7DQdKK3_OFo97eEAA4w@mail.gmail.com>
	<CAE9FiQV7EhXy8xDVQ2oWefWwje3D-DofX=yyLVbHTP1OV87QOw@mail.gmail.com>
	<1890016.dnpTzZzgDl@vostro.rjw.lan>
Date: Mon, 25 Nov 2013 11:48:40 -0800
X-Google-Sender-Auth: DOHTcvGJhFkBv7WyACAJNo726hk
Message-ID: <CAE9FiQWQ=0ZK7C_2Ex7jW8hkJmzQ4b9fitZ1SvXUrH5e8oBOow@mail.gmail.com>
Subject: Re: [PATCH] PCI: Move device_del() from pci_stop_dev() to pci_destroy_dev()
From: Yinghai Lu <yinghai@kernel.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tejun Heo <tj@kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 25, 2013 at 3:23 AM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
>>
>> or you can check if
>> http://patchwork.ozlabs.org/patch/292622/
>>   [1/6] PCI: move back pci_proc_attach_devices calling
>> http://patchwork.ozlabs.org/patch/292623/
>>   [2/6] PCI: move resources and bus_list releasing to pci_release_dev
>> http://patchwork.ozlabs.org/patch/292624/
>>   [3/6] PCI: Destroy pci dev only once
>>
>> could help with you test setup.
>
> I honestly don't think that all of the additional changes are needed to fix
> this particular problem.

I thought
[3/6] PCI: Destroy pci dev only once
should be enough, but it depend change on other two.

Thanks

Yinghai
