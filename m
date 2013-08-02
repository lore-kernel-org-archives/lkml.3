Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755043Ab3HBSEZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 14:04:25 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:52058 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754078Ab3HBSEY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 14:04:24 -0400
Message-ID: <1375466663.2034.124.camel@joe-AO722>
Subject: Re: [PATCH 00/15] NTB: Bug Fixes and New Features
From: Joe Perches <joe@perches.com>
To: Jon Mason <jon.mason@intel.com>
Cc: linux-kernel@vger.kernel.org
Date: Fri, 02 Aug 2013 11:04:23 -0700
In-Reply-To: <1375464944-27914-1-git-send-email-jon.mason@intel.com>
References: <1375464944-27914-1-git-send-email-jon.mason@intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-08-02 at 10:35 -0700, Jon Mason wrote:
> A fairly major update for NTB.  Numerous fixes and features being added,
> including adding support for NTB-RP and using DMA engines to
> transmit/receive data.  Reviews are appreciated!
> 
> Thanks,
> Jon
> 
>  MAINTAINERS                 |    2 +
>  drivers/ntb/Kconfig         |    2 +-
>  drivers/ntb/ntb_hw.c        |  483 ++++++++++++++++++++++++++++++++++---------
>  drivers/ntb/ntb_hw.h        |  105 ++++++++--
>  drivers/ntb/ntb_regs.h      |   47 +++--
>  drivers/ntb/ntb_transport.c |  382 ++++++++++++++++++++++++++--------
>  6 files changed, 802 insertions(+), 219 deletions(-)

Wouldn't this be better moved to drivers/pci/pcie/ntb ?


