Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754356AbbAFHGz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 02:06:55 -0500
Received: from g4t3426.houston.hp.com ([15.201.208.54]:60433 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964AbbAFHGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 02:06:54 -0500
Message-ID: <54AB894A.3070601@hp.com>
Date: Tue, 06 Jan 2015 15:05:46 +0800
From: "Li, ZhenHua" <zhen-hual@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Baoquan He <bhe@redhat.com>, indou.takao@jp.fujitsu.com
CC: dwmw2@infradead.org, joro@8bytes.org, vgoyal@redhat.com, dyoung@redhat.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, kexec@lists.infradead.org,
        alex.williamson@redhat.com, ddutile@redhat.com,
        ishii.hironobu@jp.fujitsu.com, bhelgaas@google.com, doug.hatch@hp.com,
        jerry.hoemann@hp.com, tom.vaden@hp.com, li.zhang6@hp.com,
        lisa.mitchell@hp.com, billsumnerlinux@gmail.com
Subject: Re: [PATCH 0/10] iommu/vt-d: Fix intel vt-d faults in kdump kernel
References: <1419239729-26529-1-git-send-email-zhen-hual@hp.com> <20150106063718.GA2454@dhcp-16-105.nay.redhat.com>
In-Reply-To: <20150106063718.GA2454@dhcp-16-105.nay.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to Takao Indoh's testing, seems adding flush after loading old 
irte and updating old irte does not fix the dmar faults.

According to Takao Indoh's log and your log, the faults happens while 
and after driver is loaded.  Maybe I am using incorrect code in 08/10.


On 01/06/2015 02:37 PM, Baoquan He wrote:
> Hi Zhenhua,
>
> I just tested your patchset based on 3.19.0-rc2+, and found several dmar
> fault and intr-remap fault, it seems not the same as Takao's, please
> check the attachment.
>
> Thanks
> Baoquan
>

