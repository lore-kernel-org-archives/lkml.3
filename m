Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760135AbaCUMAM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 08:00:12 -0400
Received: from mga09.intel.com ([134.134.136.24]:32502 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965398AbaCUMAK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 08:00:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,703,1389772800"; 
   d="scan'208";a="504634227"
Message-ID: <532C2C36.2030808@linux.intel.com>
Date: Fri, 21 Mar 2014 14:10:30 +0200
From: Mathias Nyman <mathias.nyman@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Denis Turischev <denis.turischev@compulab.co.il>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [RESEND] [PATCH] xhci: Switch Intel Lynx Point ports to EHCI
 on shutdown.
References: <532C0E0D.6070107@compulab.co.il>
In-Reply-To: <532C0E0D.6070107@compulab.co.il>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2014 12:01 PM, Denis Turischev wrote:
> The same issue like with Panther Point chipsets. If the USB ports are
> switched to xHCI on shutdown, the xHCI host will send a spurious interrupt,
> which will wake the system. Some BIOS have work around for this, but not all.
> One example is Compulab's mini-desktop, the Intense-PC2.
>
> The bug can be avoided if the USB ports are switched back to EHCI on
> shutdown.
>

I'll queue this up and send it forward to Greg once 3.15-rc1 is out

-Mathias


