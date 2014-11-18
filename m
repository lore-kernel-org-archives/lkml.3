Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755804AbaKRPjO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 10:39:14 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:46593 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754578AbaKRPjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 10:39:12 -0500
Message-ID: <546B67F5.20108@ti.com>
Date: Tue, 18 Nov 2014 21:08:29 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>, Kevin Hilman <khilman@deeprootsystems.com>
CC: Russell King <linux@arm.linux.org.uk>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] davinci: Use standard logging styles
References: <1414803111.13647.13.camel@perches.com>
In-Reply-To: <1414803111.13647.13.camel@perches.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 01 November 2014 06:21 AM, Joe Perches wrote:
> Convert printks to pr_<level> and pr_warning to pr_warn.
> 
> Other miscellanea:
> 
> o Coalesce formats
> o Realign arguments
> o Use %s, __func__ instead of embedded function names
> o Add pr_fmt to mityomapl138 and mux
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Sending to ARM-SoC for v3.19. Prefixed subject line with ARM: as is the
convention.

Thanks,
Sekhar
