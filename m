Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756798AbaCDJI1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 04:08:27 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:57140 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756480AbaCDJIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 04:08:24 -0500
Message-ID: <531597E8.50509@ti.com>
Date: Tue, 4 Mar 2014 11:07:52 +0200
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Tony Lindgren <tony@atomide.com>
CC: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/5] drivers: bus: omap_l3: Convert to use devm_kzalloc
References: <1393923710-10377-1-git-send-email-peter.ujfalusi@ti.com> <1393923710-10377-2-git-send-email-peter.ujfalusi@ti.com>
In-Reply-To: <1393923710-10377-2-git-send-email-peter.ujfalusi@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/2014 11:01 AM, Peter Ujfalusi wrote:
> We can remove the kfree() calls from probe and remove.
> 
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> Reviewed-by: Santosh Shilimkar <santosh.shilimkar@ti>

Where did the ".com" went from Santosh's email address??
I'll resend it in a minute with a fixed commit message.

-- 
Péter
