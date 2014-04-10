Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758720AbaDJQYN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 12:24:13 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:44882 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753103AbaDJQYK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 12:24:10 -0400
Message-ID: <5346C58B.6050409@ti.com>
Date: Thu, 10 Apr 2014 11:23:39 -0500
From: Joel Fernandes <joelf@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Peter Ujfalusi <peter.ujfalusi@ti.com>, <dan.j.williams@intel.com>,
        <vinod.koul@intel.com>, <nsekhar@ti.com>
CC: <dmaengine@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>, <mporter@linaro.org>
Subject: Re: [PATCH v2 05/14] arm: common: edma: Select event queue 1 as default
 when booted with DT
References: <1396357575-30585-1-git-send-email-peter.ujfalusi@ti.com> <1396357575-30585-6-git-send-email-peter.ujfalusi@ti.com>
In-Reply-To: <1396357575-30585-6-git-send-email-peter.ujfalusi@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2014 08:06 AM, Peter Ujfalusi wrote:
> Use the EVENTQ_1 for default and leave the EVENTQ_0 to be used by high
> priority channels, like audio.
> 
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>

This looks good, though another way to do it would be to leave default
to Queue 0. Put audio in Queue 1, and change QUEPRI to make Queue 1 as
higher priority.

This is fine,
Acked-by: Joel Fernandes <joelf@ti.com>

Regards,
-Joel
