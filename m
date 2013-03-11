Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752270Ab3CKFgj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 01:36:39 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:39223 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040Ab3CKFgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 01:36:37 -0400
Message-ID: <513D6DCD.20507@ti.com>
Date: Mon, 11 Mar 2013 11:08:21 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Lokesh Vutla <lokeshvutla@ti.com>
CC: <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Nishanth Menon <nm@ti.com>
Subject: Re: [PATCH 4/8] memory: emif: Handle devices which are not rated
 for >85C
References: <1362978365-5593-1-git-send-email-lokeshvutla@ti.com> <1362978365-5593-5-git-send-email-lokeshvutla@ti.com>
In-Reply-To: <1362978365-5593-5-git-send-email-lokeshvutla@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 March 2013 10:36 AM, Lokesh Vutla wrote:
> From: Nishanth Menon <nm@ti.com>
> 
> As per JESD209-2E specification for LPDDR2,
>       http://www.jedec.org/standards-documents/results/jesd209-2E
> Table 73, LPDDR2 memories come in two flavors - Standard and
> Extended. The Standard types can operate from -25C to +85C
> However, beyond that and upto +105C can only be supported by
> Extended types.
> 
right.

> Unfortunately, it seems there is no info in MR0(device info) or
> MR[1,2](device feature) for run time detection of this capability
> as far as seen on the spec. Hence, we provide a custom_config
> flag to be populated by platforms which have these "extended"
> type memories.
> 
> For the "Standard" memories, we need to consider MR4 notifications
> of temperature triggers >85C as equivalent to thermal shutdown
> events (equivalent to Spec specified thermal shutdown events for
> "extended" parts).
>
Make sense.
 
> Reported-by: Richard Woodruff <r-woodruff2@ti.com>
> Signed-off-by: Nishanth Menon <nm@ti.com>
> Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
> ---
Thanks for the fix.
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>

