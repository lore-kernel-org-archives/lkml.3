Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063Ab3CKFdJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 01:33:09 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:49319 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751122Ab3CKFdH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 01:33:07 -0400
Message-ID: <513D6CFC.6080100@ti.com>
Date: Mon, 11 Mar 2013 11:04:52 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Lokesh Vutla <lokeshvutla@ti.com>
CC: <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Ambresh K <ambresh@ti.com>, Nishanth Menon <nm@ti.com>
Subject: Re: [PATCH 2/8] memory: emif: setup LP settings on freq update
References: <1362978365-5593-1-git-send-email-lokeshvutla@ti.com> <1362978365-5593-3-git-send-email-lokeshvutla@ti.com>
In-Reply-To: <1362978365-5593-3-git-send-email-lokeshvutla@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 March 2013 10:35 AM, Lokesh Vutla wrote:
> From: Ambresh K <ambresh@ti.com>
> 
> Program the power management shadow register on freq update
> Else the concept of threshold frequencies dont really matter
> as the system always uses the performance mode timing for LP
> which is programmed in at init time.
> 
> Signed-off-by: Nishanth Menon <nm@ti.com>
> Signed-off-by: Ambresh K <ambresh@ti.com>
> Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
> ---
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
