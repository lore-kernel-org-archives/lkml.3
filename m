Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128Ab3CKFeH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 01:34:07 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:49362 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750944Ab3CKFeF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 01:34:05 -0400
Message-ID: <513D6D36.7060909@ti.com>
Date: Mon, 11 Mar 2013 11:05:50 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Lokesh Vutla <lokeshvutla@ti.com>
CC: <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Nishanth Menon <nm@ti.com>
Subject: Re: [PATCH 3/8] memory: emif: handle overflow for timing for LP mode
References: <1362978365-5593-1-git-send-email-lokeshvutla@ti.com> <1362978365-5593-4-git-send-email-lokeshvutla@ti.com>
In-Reply-To: <1362978365-5593-4-git-send-email-lokeshvutla@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 March 2013 10:36 AM, Lokesh Vutla wrote:
> From: Nishanth Menon <nm@ti.com>
> 
> In case the custom timings provide values which overflow
> the maximum possible field value, warn and use maximum
> permissible value.
> 
> Signed-off-by: Nishanth Menon <nm@ti.com>
> Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
> ---

Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>

