Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934309AbaJ2Ps1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 11:48:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43923 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933872AbaJ2Plz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 11:41:55 -0400
Date: Wed, 29 Oct 2014 16:36:10 +0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Junien Fridrick <linux.kernel@junien.fridrick.net>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        HPDD-discuss@ml01.01.org, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Doug Oucharek <doug.s.oucharek@intel.com>,
        Oleg Drokin <oleg.drokin@intel.com>,
        LABBE Corentin <clabbe.montjoie@gmail.com>,
        Isaac Huang <he.huang@intel.com>
Subject: Re: [PATCH] staging: lustre: fix sparse warning for static
 declarations
Message-ID: <20141029083610.GA9261@kroah.com>
References: <1414264176-2546-1-git-send-email-linux.kernel@junien.fridrick.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414264176-2546-1-git-send-email-linux.kernel@junien.fridrick.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 25, 2014 at 07:09:34PM +0000, Junien Fridrick wrote:
> This patch fixes the following sparse warnings :
> 
> drivers/staging/lustre/lnet/lnet/router_proc.c:167:5: warning: symbol 'proc_lnet_routes' was not declared. Should it be static?
> drivers/staging/lustre/lnet/lnet/router_proc.c:293:5: warning: symbol 'proc_lnet_routers' was not declared. Should it be static?
> drivers/staging/lustre/lnet/lnet/router_proc.c:428:5: warning: symbol 'proc_lnet_peers' was not declared. Should it be static?
> drivers/staging/lustre/lnet/lnet/router_proc.c:660:5: warning: symbol 'proc_lnet_nis' was not declared. Should it be static?
> 
> Signed-off-by: Junien Fridrick <linux.kernel@junien.fridrick.net>
> ---
> This patch is part of task 16 of the Eudyptula challenge
> Applies to next-20141023
> 
>  drivers/staging/lustre/lnet/lnet/router_proc.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)

This patch fails to apply to my tree, please refresh and try again.

thanks,

greg k-h
