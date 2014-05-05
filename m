Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751793AbaEETGt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 15:06:49 -0400
Received: from smtp.newterm.pl ([79.187.237.18]:40400 "EHLO apollo.newterm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751671AbaEETGs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 15:06:48 -0400
Date: Mon, 5 May 2014 21:06:44 +0200
From: Darek Marcinkiewicz <reksio@newterm.pl>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: davem@davemloft.net, romieu@fr.zoreil.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 1/1] Driver for Beckhoff CX5020 EtherCAT master module.
Message-ID: <20140505190644.GJ1156@newterm.pl>
References: <20140504200800.GH1156@newterm.pl>
 <6140861.bbEgARIqZU@amdc1032>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6140861.bbEgARIqZU@amdc1032>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2014 at 04:32:49PM +0200, Bartlomiej Zolnierkiewicz wrote:
> 
> Hi,
> 
Hi.
> 
> There needs to be at least
> 
> 	depends on PCI
> 
> here or the driver will break build on platforms that doesn't have PCI
> (i.e. ARM EXYNOS).
> 
Thank you. I'll update the patch.

-- 
DM
