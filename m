Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547Ab3JBPCw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 11:02:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50760 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752926Ab3JBPCu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 11:02:50 -0400
Date: Wed, 2 Oct 2013 17:02:45 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Manoj Chourasia <mchourasia@nvidia.com>
Cc: "Mika Westerberg (mika.westerberg@linux.intel.com)" 
	<mika.westerberg@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: FW: [PATCH] hidraw: close underlying device at removal of last
 reader
In-Reply-To: <F1F6C959961EA744BBD5B8EEF8B8FEA16DDD19DD43@BGMAIL02.nvidia.com>
Message-ID: <alpine.LNX.2.00.1310021702330.29701@pobox.suse.cz>
References: <F1F6C959961EA744BBD5B8EEF8B8FEA16DDD19DD43@BGMAIL02.nvidia.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Oct 2013, Manoj Chourasia wrote:

> Hi Jiri,
> 
> Mika Westerberg mika.westerberg@linux.intel.com reported a bug introduced in hid driver after 
> commit 212a871a393 (HID: hidraw: correctly deallocate memory on device disconnect) 
> that hidraw doesn't close the underlying hid device when the device node is closed last time.
> 
> I am proposing following patch as fix.  Please review it.  Mika will help in testing.
> 
> ----------------------------------------
> >From b37519b65be0d51b90c5fc177c0dc0cd2f6358b1 Mon Sep 17 00:00:00 2001
> From: Manoj Chourasia <mchourasia@nvidia.com>
> Date: Tue, 1 Oct 2013 15:39:00 +0530
> Subject: [PATCH] HID: hidraw: close underlying device at removal of last reader
> 
> Even though device exist bit is set the underlying
> HW device should be closed when the last reader
> of the device is closed i.e. open count drops to zero.
> 
> Signed-off-by: Manoj Chourasia <mchourasia@nvidia.com>

Applied, thanks a lot to both of you.

-- 
Jiri Kosina
SUSE Labs
