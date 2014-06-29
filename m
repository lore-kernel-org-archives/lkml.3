Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959AbaF3Cu0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 22:50:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34312 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753607AbaF3CuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 22:50:25 -0400
Date: Sun, 29 Jun 2014 14:21:44 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Daeseok Youn <daeseok.youn@gmail.com>
Cc: devel@driverdev.osuosl.org, shaun@XResource.ca, weo@weo1.de,
        sachin.kamat@linaro.org, peter.p.waskiewicz.jr@intel.com,
        linux-kernel@vger.kernel.org, himangi774@gmail.com, fempsci@gmail.com
Subject: Re: [PATCH 1/3] staging: cxt1e1: Remove useless OS_phystov() and
 OS_vtophys()
Message-ID: <20140629212144.GA12303@kroah.com>
References: <20140627095226.GA9420@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140627095226.GA9420@devel.8.8.4.4>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2014 at 06:52:26PM +0900, Daeseok Youn wrote:
> OS_phystov()/OS_vtophys() are replaced with __va()/__pa().

No, you should use virt_to_phys() and phys_to_virt() instead of these
internal macros which might not be correct for all architectures.

thanks,

greg k-h
