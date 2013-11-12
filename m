Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570Ab3KLS2R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 13:28:17 -0500
Received: from mga03.intel.com ([143.182.124.21]:46229 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753081Ab3KLS2Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 13:28:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,686,1378882800"; 
   d="scan'208";a="426367875"
Message-ID: <528272C9.30301@linux.intel.com>
Date: Tue, 12 Nov 2013 10:26:17 -0800
From: David Cohen <david.a.cohen@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131005 Icedove/17.0.9
MIME-Version: 1.0
To: Michal Nazarewicz <mina86@mina86.com>
CC: balbi@ti.com, gregkh@linuxfoundation.org, stern@rowland.harvard.edu,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv5.1 4/5] check quirk to pad epout buf size when not aligned
 to maxpacketsize
References: <1384201011-11114-1-git-send-email-david.a.cohen@linux.intel.com> <1384201011-11114-5-git-send-email-david.a.cohen@linux.intel.com> <xa1ttxfiwkw0.fsf@mina86.com> <52817251.3040509@linux.intel.com> <xa1twqkdlqr8.fsf@mina86.com>
In-Reply-To: <xa1twqkdlqr8.fsf@mina86.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2013 04:59 AM, Michal Nazarewicz wrote:
> On Tue, Nov 12 2013, David Cohen wrote:
>> You need to update req->length otherwise it's going to crash DWC3.
>> I'd rather to keep your previous version.
> 
> That's unfortunate.  Do you want me to resend it or will you just send
> a v6 of your whole series?

Alan disagreed and proposed a good approach to fix req->length inside
DWC3. We can keep this patch of yours but I'll need to change mine to
DWC3. I'll send a v6 with update on my patch.

Br, David

