Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480AbaARDsc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 22:48:32 -0500
Received: from mga03.intel.com ([143.182.124.21]:44124 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752608AbaARDsa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 22:48:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,677,1384329600"; 
   d="scan'208";a="460798863"
Message-ID: <52D9F98A.2090003@linux.intel.com>
Date: Sat, 18 Jan 2014 11:48:26 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Toshi Kani <toshi.kani@hp.com>,
        Yijing Wang <wangyijing@huawei.com>, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Patch v1 2/3] ACPI, PCI: reuse ACPI hotplug framework to support
 PCI host bridge hotplug
References: <1390013297-23462-1-git-send-email-jiang.liu@linux.intel.com>	<1390013297-23462-2-git-send-email-jiang.liu@linux.intel.com> <CAE9FiQXS-vctiWtXBcw8g6dqPEJGSND+GXB1t64kEoCiygBhjQ@mail.gmail.com>
In-Reply-To: <CAE9FiQXS-vctiWtXBcw8g6dqPEJGSND+GXB1t64kEoCiygBhjQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi yinghai,
	Sorry for the noise. I didn't noticed Rafael's work,
so I generated this patchset when encountered this issue
during testing PCI host bridge hotplug. It should achieve
the same goal.
Thanks!
Gerry

On 2014/1/18 11:23, Yinghai Lu wrote:
> ACPI / hotplug: Make ACPI PCI root hotplug use common hotplug code
