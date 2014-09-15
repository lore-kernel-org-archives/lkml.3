Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756772AbaIOViU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 17:38:20 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:41484 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755128AbaIOViS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 17:38:18 -0400
Date: Mon, 15 Sep 2014 23:38:02 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Pete Clements <clem@clem.clem-digital.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: 3.17-rc5 fails compile (arch/x86/pci/irq.c)
Message-ID: <20140915213802.GA11510@electric-eye.fr.zoreil.com>
References: <201409151104.s8FB413m027949@clem.clem-digital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201409151104.s8FB413m027949@clem.clem-digital.net>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pete Clements <clem@clem.clem-digital.net> :
> Fyi: i386 up  -- problem introduced in rc3.

Fix available for ~2 weeks:

https://lkml.kernel.org/r/1409382916-10649-1-git-send-email-jiang.liu@linux.intel.com

-- 
Ueimor
