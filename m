Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906AbbA2Gmb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 01:42:31 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:36613 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755708AbbA2Gma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 01:42:30 -0500
Date: Wed, 28 Jan 2015 22:42:28 -0800 (PST)
Message-Id: <20150128.224228.1533046356464752424.davem@davemloft.net>
To: behanw@converseincode.com
Cc: sathya.perla@emulex.com, ajit.khaparde@emulex.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        subbu.seetharaman@emulex.com, arnd@arndb.de
Subject: Re: [PATCH] net, ethernet, LLVMLinux: Add missing
 MODULE_DEVICE_TABLE()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1422495374-22835-1-git-send-email-behanw@converseincode.com>
References: <1422495374-22835-1-git-send-email-behanw@converseincode.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 28 Jan 2015 22:42:29 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Behan Webster <behanw@converseincode.com>
Date: Wed, 28 Jan 2015 17:36:14 -0800

> Missing MODULE_DEVICE_TABLE for pci ids from benet driver found by clang.
> 
> Signed-off-by: Behan Webster <behanw@converseincode.com>
> Suggested-by: Arnd Bergmann <arnd@arndb.de>

Why are you removing the device table?

Second of all, your Subject needs to be adjusted, using "net" and
"LLVMLinux" in your subsystem prefix is not appropriate.  Simply
"be2net: ", the name of this driver, is sufficient.

