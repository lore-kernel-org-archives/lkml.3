Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235Ab3JIGbp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 02:31:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47783 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756013Ab3JIGbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 02:31:42 -0400
Date: Tue, 8 Oct 2013 23:19:20 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Fabio Estevam <fabio.estevam@freescale.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Guenter Roeck <linux@roeck-us.net>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the tty-next tree
Message-ID: <20131009061920.GA5645@kroah.com>
References: <1381239855-16314-1-git-send-email-treding@nvidia.com>
 <1381239855-16314-5-git-send-email-treding@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381239855-16314-5-git-send-email-treding@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 08, 2013 at 03:44:15PM +0200, Thierry Reding wrote:
> Today's linux-next merge of the tty-next tree got a conflict in
> 
> 	drivers/tty/serial/imx.c
> 
> caused by commits e2c2725 (serial: imx: Use NULL as the last argument of
> add_preferred_console()) and b4e788d (Revert "serial: i.MX: evaluate
> linux,stdout-path property").
> 
> The former commit only changes a parameter from 0 to NULL I assume it
> doesn't solve the build breakage mentioned as reason for the revert, so
> I kept the reversion.

That sounds correct, thanks.

greg k-h
