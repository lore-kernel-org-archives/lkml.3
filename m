Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755235Ab3BADbB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 22:31:01 -0500
Received: from mga09.intel.com ([134.134.136.24]:26017 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752492Ab3BADa7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 22:30:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,579,1355126400"; 
   d="scan'208";a="279463624"
Date: Fri, 1 Feb 2013 10:38:15 -0500
From: Youquan Song <youquan.song@linux.intel.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: Youquan Song <youquan.song@intel.com>, htejun@gmail.com,
        ming.lei@canonical.com, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, seth.heasley@intel.com, jlee@suse.com,
        james.d.ralston@intel.com, Youquan Song <youquan.song@linux.intel.com>
Subject: Re: [PATCH] ata: Fix DVD not dectected at some Haswell platforms
Message-ID: <20130201153815.GB2186@linux-youquan.bj.intel.com>
References: <1359566374-27286-1-git-send-email-youquan.song@intel.com> <5109121F.1000205@mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5109121F.1000205@mvista.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> +	{ 0x8086, 0x8c08, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata_snb },
>>   	/* SATA Controller IDE (Lynx Point) */
>>   	{ 0x8086, 0x8c09, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
>
>    Also, are you sure this one and the following Lynx Point controllers are 
> not affected?

I am not sure. the 0x8c09 is possibly used on mobile PC not desktop. On
one of my machine, it includes the chipset but the 2 ports IDE controller is
not extend out for use. There are only 2 ports extended out from 4 ports
IDE controller.  So I can not verify it. I think, the notebook/mobile PC does
 not require to extends out all of the IDE ports. 

This patch only fixs the 0x8c08 2 ports IDE controller for it block the
installation. If there is an issue reporting from 0x8c09, we can fix it
late.

Thanks
-Youuquan

