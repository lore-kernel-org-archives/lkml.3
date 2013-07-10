Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996Ab3GJJR1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 05:17:27 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:37671 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753970Ab3GJJRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 05:17:24 -0400
Message-ID: <51DD2699.7000804@linux.vnet.ibm.com>
Date: Wed, 10 Jul 2013 14:47:13 +0530
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: "Luck, Tony" <tony.luck@intel.com>
CC: Borislav Petkov <bp@alien8.de>, "ananth@in.ibm.com" <ananth@in.ibm.com>,
        "masbock@linux.vnet.ibm.com" <masbock@linux.vnet.ibm.com>,
        "lcm@linux.vnet.ibm.com" <lcm@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>
Subject: Re: [PATCH 4] mce: acpi/apei: Add a sysctl to control page offlining
 on firmware report
References: <20130701153728.6197.14022.stgit@localhost.localdomain> <20130702125137.7388.97225.stgit@localhost.localdomain> <20130703144641.GC13951@pd.tnic> <51D44752.3000303@linux.vnet.ibm.com> <3908561D78D1C84285E8C5FCA982C28F31C76B19@ORSMSX106.amr.corp.intel.com>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F31C76B19@ORSMSX106.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071009-0260-0000-0000-0000034A2BE4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/2013 01:56 AM, Luck, Tony wrote:
> I'm happy with just the acpi=nocmcff to avoid a BIOS that does weird
> stuff.  Or do you think we might still have to deal with a string of APEI
> messages?

Agreed - and I don't think this patch can help with a string of APEI 
messages either. So yes, I think we can leave this out for now.

Thanks,
Naveen

