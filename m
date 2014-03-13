Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754982AbaCMTUs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 15:20:48 -0400
Received: from mga11.intel.com ([192.55.52.93]:7224 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752216AbaCMTUr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 15:20:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,648,1389772800"; 
   d="scan'208";a="497988752"
Date: Thu, 13 Mar 2014 15:20:45 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: liaohengquan1986 <liaohengquan1986@163.com>
Cc: Alexander Gordeev <agordeev@redhat.com>, linux-kernel@vger.kernel.org,
        Keith Busch <keith.busch@intel.com>, linux-nvme@lists.infradead.org
Subject: Re: problem in the development of nvme disk
Message-ID: <20140313192045.GD6091@linux.intel.com>
References: <cover.1390897693.git.agordeev@redhat.com>
 <20140311150841.GA25564@dhcp-26-207.brq.redhat.com>
 <196070e8.d690.144bb7e553f.Coremail.liaohengquan1986@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <196070e8.d690.144bb7e553f.Coremail.liaohengquan1986@163.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2014 at 08:50:22PM +0800, liaohengquan1986 wrote:
> Hi , guys,
> 
>                today, I get a problem in the development of NVMe disk. After insmod the NVMe driver(nvme.ko), I already found the
> 
> /dev/nvme0n1 block device, bus when I run " fdisk /dev/nvme0n1", the entire host server is broken down and reset. The host server's OS is Linux SUSE 11 sp3, . I want to know if it is the OS' bug, the system log is below, please help me, TKS.

Can you reproduce this with the mainline kernel, eg 3.13?
