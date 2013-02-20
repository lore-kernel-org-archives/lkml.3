Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964829Ab3BTPnx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 10:43:53 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:34702 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S935893Ab3BTPnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 10:43:51 -0500
Date: Wed, 20 Feb 2013 10:43:50 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Aaron Lu <aaron.lu@intel.com>
cc: Jens Axboe <axboe@kernel.dk>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        <linux-pm@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-ide@vger.kernel.org>,
        Aaron Lu <aaron.lwe@gmail.com>, Shane Huang <shane.huang@amd.com>
Subject: Re: [PATCH v10 0/4] block layer runtime pm
In-Reply-To: <1361340717-8991-1-git-send-email-aaron.lu@intel.com>
Message-ID: <Pine.LNX.4.44L0.1302201042400.1671-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Feb 2013, Aaron Lu wrote:

> In August 2010, Jens and Alan discussed about "Runtime PM and the block
> layer". http://marc.info/?t=128259108400001&r=1&w=2
> And then Alan has given a detailed implementation guide:
> http://marc.info/?l=linux-scsi&m=133727953625963&w=2

> v10:
> - Add link of Alan Stern's ideas on block layer runtime PM to patch 2
>   and 3's changelog;
> - Add back code to schdule device suspend if scsi driver return -EBUSY.

This all looks okay now.  You can add

Acked-by: Alan Stern <stern@rowland.harvard.edu>

to each of the patches.

Alan Stern

