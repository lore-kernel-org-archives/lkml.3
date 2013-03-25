Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933195Ab3CYULm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 16:11:42 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:50725 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932801Ab3CYULk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 16:11:40 -0400
Date: Mon, 25 Mar 2013 13:11:37 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Olaf Hering <olaf@aepfle.de>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, apw@canonical.com, jasowang@redhat.com,
        Evgeniy Polyakov <zbr@ioremap.net>
Subject: Re: [PATCH V2 1/1] Drivers: hv: Add a new driver to support host
 initiated backup
Message-ID: <20130325201137.GA26531@kroah.com>
References: <1363375806-19979-1-git-send-email-kys@microsoft.com>
 <20130322161453.GA2767@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130322161453.GA2767@aepfle.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 22, 2013 at 05:14:53PM +0100, Olaf Hering wrote:
> On Fri, Mar 15, K. Y. Srinivasan wrote:
> 
> > This driver has a user-level component (daemon) that invokes the appropriate
> 
> This change fixes a few compile errors:
> 
> hv_vss_daemon.c:64:15: warning: unknown escape sequence '\/'
> hv_vss_daemon.c:64:15: warning: unknown escape sequence '\/'
> hv_vss_daemon.c: In function 'vss_operate':
> hv_vss_daemon.c:66: warning: 'return' with no value, in function returning non-void
> hv_vss_daemon.c: In function 'main':
> hv_vss_daemon.c:130: warning: ignoring return value of 'daemon', declared with attribute warn_unused_result
> hv_vss_daemon.c: In function 'vss_operate':
> hv_vss_daemon.c:47: warning: 'fs_op' may be used uninitialized in this function
> 
> Signed-off-by: Olaf Hering <olaf@aepfle.de>

Please resend with a proper subject: and changelog entry.

thanks,

greg k-h
