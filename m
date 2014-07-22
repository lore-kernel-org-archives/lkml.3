Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755638AbaGVPAz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 11:00:55 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:54040 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755344AbaGVPAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 11:00:52 -0400
Message-ID: <53CE7C9C.6060107@ti.com>
Date: Tue, 22 Jul 2014 10:00:44 -0500
From: Suman Anna <s-anna@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Tobias Klauser <tklauser@distanz.ch>, Tony Lindgren <tony@atomide.com>
CC: Jingoo Han <jg1.han@samsung.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mailbox/omap: Use module_platform_driver
References: <1406031223-15759-1-git-send-email-tklauser@distanz.ch>
In-Reply-To: <1406031223-15759-1-git-send-email-tklauser@distanz.ch>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tobias,

On 07/22/2014 07:13 AM, Tobias Klauser wrote:
> Use the module_platform_driver to omit module init/exit boilerplate code.
> 
> Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
> ---
>  drivers/mailbox/mailbox-omap1.c | 13 +------------
>  drivers/mailbox/mailbox-omap2.c | 13 +------------
>  2 files changed, 2 insertions(+), 24 deletions(-)

I have submitted a series that cleans up/consolidates the OMAP mailbox
driver [1], and this patch won't be necessary as the same lines get deleted.

regards
Suman

[1] http://www.spinics.net/lists/linux-omap/msg108574.html
