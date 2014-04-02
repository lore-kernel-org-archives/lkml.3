Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758113AbaDBIYI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 04:24:08 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:64763 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757462AbaDBIYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 04:24:06 -0400
Message-ID: <1396427043.18431.20.camel@x220>
Subject: Re: [GIT PULL] Staging driver patches for 3.15-rc1
From: Paul Bolle <pebolle@tiscali.nl>
To: Greg KH <gregkh@linuxfoundation.org>,
        Insop Song <insop.song@gainspeed.com>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Date: Wed, 02 Apr 2014 10:24:03 +0200
In-Reply-To: <20140401184817.GA21855@kroah.com>
References: <20140401184817.GA21855@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Apr 2014 08:24:03.0730 (UTC) FILETIME=[E834F720:01CF4E4C]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-04-01 at 11:48 -0700, Greg KH wrote:
> Staging driver pull request for 3.15-rc1
> 
> Here's the huge drivers/staging/ update for 3.15-rc1.
> 
> Loads of cleanup fixes, a few drivers removed, and some new ones added.
> 
> All have been in linux-next for a while.
>
>[...]
>
> Insop Song (1):
>       staging: fpgaboot: Xilinx FPGA firmware download driver

This commit adds checks for CONFIG_B4860G100. Is a patch to add a
Kconfig symbol B4860G100 perhaps queued somewhere?

It also adds this Makefile line:
    ccflags-$(CONFIG_GS_FPGA_DEBUG)    := -DDEBUG

But there's no Kconfig symbol GS_FGPA_DEBUG. On the other hand, the code
involved doesn't seem to use either DEBUG or dev_dbg() so perhaps it
isn't actually needed. (But note that the code does check for
DEBUG_FPGA, which apparently has to be set manually.)


Paul  Bolle

