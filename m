Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751525AbaIERxd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 13:53:33 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:44580 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776AbaIERxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 13:53:31 -0400
Date: Sat, 6 Sep 2014 02:53:26 +0900
From: Tejun Heo <tj@kernel.org>
To: Murali Karicheri <m-karicheri2@ti.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: Re: [RESEND: PATCH] ahci: add pcid for Marvel 0x9182 controller
Message-ID: <20140905175326.GB12991@mtj.dyndns.org>
References: <1409937660-30544-1-git-send-email-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409937660-30544-1-git-send-email-m-karicheri2@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 05, 2014 at 01:21:00PM -0400, Murali Karicheri wrote:
> Keystone K2E EVM uses Marvel 0x9182 controller. This requires support
> for the ID in the ahci driver.
> 
> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>

Applied to libata/for-3.17-fixes w/ stable cc'd.

Thanks.

-- 
tejun
