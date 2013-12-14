Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155Ab3LNVXQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 16:23:16 -0500
Received: from mail-qe0-f42.google.com ([209.85.128.42]:48202 "EHLO
	mail-qe0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554Ab3LNVXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 16:23:14 -0500
Date: Sat, 14 Dec 2013 16:23:11 -0500
From: Tejun Heo <tj@kernel.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        josh@joshtriplett.org
Subject: Re: [PATCH 2/2] drivers: ata: Mark the function as static in
 libahci.c
Message-ID: <20131214212311.GA13216@htj.dyndns.org>
References: <81391ee13d565f1db31247dfda803cd7123bb8a9.1387029964.git.rashika.kheria@gmail.com>
 <a4302d91071258c77de3e4086845adf630a3f8d6.1387029964.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a4302d91071258c77de3e4086845adf630a3f8d6.1387029964.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 14, 2013 at 07:40:21PM +0530, Rashika Kheria wrote:
> This patch marks the function ahci_port_intr() and
> ahci_hw_port_interrupt() as static in libahci.c because they are not
> used outside this file.
> 
> Thus, it also eliminates the following warnings in libahci.c:
> drivers/ata/libahci.c:1767:6: warning: no previous prototype for ‘ahci_port_intr’ [-Wmissing-prototypes]
> drivers/ata/libahci.c:1800:6: warning: no previous prototype for ‘ahci_hw_port_interrupt’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>

Applied 1-2 to libata/for-3.14.

Thanks.

-- 
tejun
