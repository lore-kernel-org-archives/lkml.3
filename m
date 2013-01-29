Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756737Ab3A2QCw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 11:02:52 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:47332 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022Ab3A2QCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 11:02:49 -0500
Date: Tue, 29 Jan 2013 10:02:44 -0600
From: Nishanth Menon <nm@ti.com>
To: Ruslan Bilovol <ruslan.bilovol@ti.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <tony@atomide.com>,
        <linux@arm.linux.org.uk>, <eduardo.valentin@ti.com>
Subject: Re: [RFC PATCH 0/2] ARM: update cpuinfo to print CPU model name
Message-ID: <20130129160243.GA3389@kahuna>
References: <1359474865-15408-1-git-send-email-ruslan.bilovol@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1359474865-15408-1-git-send-email-ruslan.bilovol@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17:54-20130129, Ruslan Bilovol wrote:
> Hi,
> 
> The following patches update cpuinfo to print CPU
> model name for ARM. First patch exactly makes needed
> changes for ARM architecture.
> Second patch adds this ability to OMAP4 SoCs.
> 
> This adds a common approach to show SoC name.
> 
> Looks like there were few attempts to do similar
> changes to cpuinfo without any luck.
> 
> So - comments are welcome
> 
> Ruslan Bilovol (2):
>   ARM: kernel: update cpuinfo to print CPU model name
>   ARM: OMAP4: setup CPU model name during ID initialisation

We had an discussion on similar lines but a generic suggestion:
https://patchwork.kernel.org/patch/98720/
SoCinfo framework which was supposed to introduce this

Would'nt that be a better approach to take than an OMAP only solution?

Ccying eduardo who had driven this for some time.
-- 
Regards,
Nishanth Menon
