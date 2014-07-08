Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962AbaGHXlr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 19:41:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38053 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513AbaGHXlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 19:41:46 -0400
Date: Tue, 8 Jul 2014 16:46:10 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Fabio Falzoi <fabio.falzoi84@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org, joe@perches.com,
        dan.carpenter@oracle.com, wei_wang@realsil.com.cn,
        micky_ching@realsil.com.cn
Subject: Re: [PATCH v3 1/4] Staging: rts5208: Replace custom macro with
 pr_debug
Message-ID: <20140708234610.GB25645@kroah.com>
References: <1404855512-5864-1-git-send-email-fabio.falzoi84@gmail.com>
 <1404855512-5864-2-git-send-email-fabio.falzoi84@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404855512-5864-2-git-send-email-fabio.falzoi84@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2014 at 11:38:29PM +0200, Fabio Falzoi wrote:
> Use pr_debug macro to control tracing verbosity through dynamic debug facility.

For almost all of these, you should use dev_dbg() instead, as you have
access to a struct device (well, you should have, you might have to dig
for it...)

thanks,

greg k-h
