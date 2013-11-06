Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134Ab3KFIvz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 03:51:55 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:46931 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753228Ab3KFIvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 03:51:54 -0500
Date: Wed, 6 Nov 2013 08:51:27 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        matt.fleming@intel.com, tony.luck@intel.com, tomoki.sekiyama@hds.com,
        dle-develop@lists.sourceforge.net, Madper Xie <cxie@redhat.com>
Subject: Re: [PATCH v4] efivars,efi-pstore: Hold off deletion of sysfs entry
 until the scan is completed
Message-ID: <20131106085127.GB22856@console-pimps.org>
References: <52715D9E.10701@hds.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52715D9E.10701@hds.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Oct, at 03:27:26PM, Seiji Aguchi wrote:
>  drivers/firmware/efi/efi-pstore.c | 143 +++++++++++++++++++++++++++++++++++---
>  drivers/firmware/efi/efivars.c    |  12 ++--
>  drivers/firmware/efi/vars.c       |  12 +++-
>  include/linux/efi.h               |   4 ++
>  4 files changed, 155 insertions(+), 16 deletions(-)

Tony, want me to pick this up since it touches various EFI bits?

-- 
Matt Fleming, Intel Open Source Technology Center
