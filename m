Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751557AbaBLH5p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 02:57:45 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:26749 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055AbaBLH5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 02:57:43 -0500
Message-ID: <52FB2968.3090904@huawei.com>
Date: Wed, 12 Feb 2014 15:57:28 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
CC: Bjorn Helgaas <bhelgaas@google.com>, <linux-kernel@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, Hanjun Guo <guohanjun@huawei.com>,
        Paul Bolle <pebolle@tiscali.nl>, Oliver Neukum <oneukum@suse.de>
Subject: Re: [PATCH part1 v6 4/7] PCI: Introduce pci_serial_number_changed()
References: <1392173573-59844-1-git-send-email-wangyijing@huawei.com> <1392173573-59844-5-git-send-email-wangyijing@huawei.com> <52FB2222.20402@cn.fujitsu.com>
In-Reply-To: <52FB2222.20402@cn.fujitsu.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> + * pci_serial_number_changed - check the device SN is changed
> 
> How about the name “pci_device_changed”? I think it's more readable,
> though the judgement is according to SN.

Ah, it's nice, will update in next version.

Thanks!
Yijing.

> 
> Regards,
> Gu
> 
>> + * @pdev: the PCI device
>> + *
>> + * check the device serial number is changed.
>> + * if device does not support device serial number,
>> + * return false.
>> + */
>> +bool pci_serial_number_changed(struct pci_dev *pdev)
>> +{
>> +	u64 old, new;

