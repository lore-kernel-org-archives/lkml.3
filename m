Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004Ab3AaJwA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 04:52:00 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:38457 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753585Ab3AaJv6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 04:51:58 -0500
Message-ID: <510A3EAE.107@ti.com>
Date: Thu, 31 Jan 2013 15:21:42 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Vishwanathrao Badarkhe, Manish" <manishv.b@ti.com>
CC: <linux-arm-kernel@lists.infradead.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-kernel@vger.kernel.org>, <linux@arm.linux.org.uk>,
        <khilman@deeprootsystems.com>
Subject: Re: [PATCH RFC] davinci: poll for sleep completion in resume routine.
References: <1359624393-5898-1-git-send-email-manishv.b@ti.com>
In-Reply-To: <1359624393-5898-1-git-send-email-manishv.b@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 1/31/2013 2:56 PM, Vishwanathrao Badarkhe, Manish wrote:
> As per OMAP-L138 TRM, Software must poll for
> SLEEPCOMPLETE bit until it is set to 1 before clearing
> SLEEPENABLE bit in DEEPSLEEP register in resume routine.
> Modifications are as per datasheet:
> http://www.ti.com/lit/ug/spruh77a/spruh77a.pdf
> See sections 10.10.2.2 and 11.5.21 for more detailed
> explanation.
> 
> Tested on da850-evm.
> 
> Signed-off-by: Vishwanathrao Badarkhe, Manish <manishv.b@ti.com>

Is this a bug fix? Do you see any issue without this patch?

Thanks,
Sekhar
