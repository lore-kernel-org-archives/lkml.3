Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756420AbaFQTSe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 15:18:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55401 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756396AbaFQTSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 15:18:31 -0400
Date: Tue, 17 Jun 2014 12:22:28 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Jeff Liu <jeff.liu@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 10/24] drivers/base: return actual error on sysfs init
Message-ID: <20140617192228.GD4319@kroah.com>
References: <53A05277.7060900@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53A05277.7060900@oracle.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2014 at 10:36:39PM +0800, Jeff Liu wrote:
> From: Jie Liu <jeff.liu@oracle.com>
> 
> This patch fix all sysfs init functions under drivers core to
> return the actual error code than the hardcoded ENOMEM.
> 
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> ---
>  drivers/base/bus.c   | 16 ++++++++--------
>  drivers/base/class.c |  4 ++--
>  drivers/base/core.c  |  4 ++--
>  3 files changed, 12 insertions(+), 12 deletions(-)

Nope, not taking this.

