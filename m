Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240Ab3IJBIe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 21:08:34 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:48906 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755756Ab3IJBIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 21:08:32 -0400
Message-ID: <522E7035.6060404@huawei.com>
Date: Tue, 10 Sep 2013 09:04:53 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: "Marciniszyn, Mike" <mike.marciniszyn@intel.com>
CC: Bjorn Helgaas <bhelgaas@google.com>, Chris Metcalf <cmetcalf@tilera.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Airlie <airlied@linux.ie>, infinipath <infinipath@intel.com>,
        Roland Dreier <roland@kernel.org>,
        Roland Dreier <roland@purestorage.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Einon <mark.einon@gmail.com>,
        "Hefty, Sean" <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Hanjun Guo <guohanjun@huawei.com>
Subject: Re: [PATCH 4/6] IB/qib: Use pcie_set_mps() and pcie_get_mps() to
 simplify code
References: <1378732388-4508-1-git-send-email-wangyijing@huawei.com> <1378732388-4508-5-git-send-email-wangyijing@huawei.com> <32E1700B9017364D9B60AED9960492BC2119F081@FMSMSX107.amr.corp.intel.com>
In-Reply-To: <32E1700B9017364D9B60AED9960492BC2119F081@FMSMSX107.amr.corp.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/9/9 22:55, Marciniszyn, Mike wrote:
>> Subject: [PATCH 4/6] IB/qib: Use pcie_set_mps() and pcie_get_mps() to simplify
>> code
>>
>> Refactor qib_tune_pcie_caps() function, use pcie_set_mps() and
>> pcie_get_mps() to simply code. Because pci core caches the "PCI-E Max
>> Payload Size Supported" in pci_dev->pcie_mpss, so use that instead of
>> pcie_capability_read_word(). Remove the unused val2fld() and fld2val().
>>
> 
> I tested this patch as is and saw no issues.
> 
> The only thing I would suggest is that the new use of pcie_get_readrq/pcie_set_readrq() be reflected in the comments with an appropriate adjustment in the subject.

Hi Mike,
   Thanks for your tests very much! Ok, I will update the comments.

Thanks!
Yijing.

> 
> Mike
> 
>  
> 
> .
> 


-- 
Thanks!
Yijing

