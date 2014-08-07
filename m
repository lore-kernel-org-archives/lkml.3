Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807AbaHGDJN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 23:09:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40439 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754120AbaHGDJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 23:09:11 -0400
Date: Wed, 6 Aug 2014 20:08:40 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: A Raghavendra Rao <raghav3276@gmail.com>
Cc: peter.p.waskiewicz.jr@intel.com, c@24.io, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, A Raghavendra Rao <arrao@cdac.in>
Subject: Re: [PATCH] staging: rtl8192u: fix sparse warnings in r8192U_core.c
Message-ID: <20140807030840.GA2807@kroah.com>
References: <1407314656-24471-1-git-send-email-arrao@cdac.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407314656-24471-1-git-send-email-arrao@cdac.in>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2014 at 02:14:16PM +0530, A Raghavendra Rao wrote:
> Fix the following sparse warnings:
> drivers/staging/rtl8192u/r8192U_core.c:670:6: warning: symbol 'dump_eprom'
> was not declared. Should it be static?
> drivers/staging/rtl8192u/r8192U_core.c:1556:14: warning: symbol
> 'txqueue2outpipe' was not declared. Should it be static?
> drivers/staging/rtl8192u/r8192U_core.c:4876:5: warning: symbol
> 'GetRxPacketShiftBytes819xUsb' was not declared. Should it be static?
> 
> Signed-off-by: A Raghavendra Rao <arrao@cdac.in>
> ---
>  drivers/staging/rtl8192u/r8192U_core.c |    8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)

This patch causes warnings to be added to the build, don't do that :(
