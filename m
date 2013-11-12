Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757079Ab3KLVBk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 16:01:40 -0500
Received: from mga11.intel.com ([192.55.52.93]:12896 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756991Ab3KLVBd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 16:01:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,687,1378882800"; 
   d="scan'208";a="432302083"
Message-ID: <52829837.3050501@linux.intel.com>
Date: Tue, 12 Nov 2013 13:05:59 -0800
From: David Cohen <david.a.cohen@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131005 Icedove/17.0.9
MIME-Version: 1.0
To: David Cohen <david.a.cohen@linux.intel.com>
CC: balbi@ti.com, gregkh@linuxfoundation.org, stern@rowland.harvard.edu,
        mina86@mina86.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 0/5] add gadget quirk to adapt f_fs for DWC3
References: <1384290286-21432-1-git-send-email-david.a.cohen@linux.intel.com>
In-Reply-To: <1384290286-21432-1-git-send-email-david.a.cohen@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2013 01:04 PM, David Cohen wrote:
> Hi,
>
> These patches are a proposal to add gadget quirks in an immediate objective to
> adapt f_fs when using DWC3 controller. But the quirk solution is generic and
> can be used by other controllers to adapt gadget functions to their
> non-standard restrictions.
>
> This change is necessary to make Android's adbd service to work on Intel
> Merrifield with f_fs instead of out-of-tree android gadget.
>
> This new patch set was tested and validated in my environment:
>   - Intel Merrifield was able to use DWC3/f_fs with adbd service (it wasn't
>     before).
>
> Changes from v45 to v6:

I hope not have to get to v45 :) but I meant v5.
