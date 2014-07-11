Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751523AbaGKHMx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 03:12:53 -0400
Received: from smtpdg94.aruba.it ([62.149.158.94]:33933 "EHLO
	smtpdg94.aruba.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154AbaGKHMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 03:12:51 -0400
From: Davide Gianforte <davide@gengisdave.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        kernel-janitors <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH 2/2] staging: silicom: function return fixes
Date: Fri, 11 Jul 2014 09:12:25 +0200
Message-ID: <3841595.FCr3AICt7G@mayhem>
User-Agent: KMail/4.13.2 (Linux/3.15.5; KDE/4.13.2; x86_64; ; )
In-Reply-To: <20140709185914.GA28612@kroah.com>
References: <1972083.WZLDx2N35Z@mayhem> <1488578.ritUTSl26I@mayhem> <20140709185914.GA28612@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2014 at 11:59:14, Greg Kroah-Hartman wrote:
> On Tue, Jul 01, 2014 at 02:33:43PM +0200, Davide Gianforte wrote:
> > +	uint32_t ctrl_ext = BPCTL_READ_REG(pbpctl_dev, CTRL_EXT);
> >  
> > -	ctrl_ext = BPCTL_READ_REG(pbpctl_dev, CTRL_EXT);
> 
> How about just removing the " = 0;" part of the variable definition?
> That would be a smaller patch, and still keep everything "clean".
> 
> thanks,
> 
> greg k-h

Also I prefer the style to keep definitions separated from assignments.
I've seen a lot of kernel code which initialize variables with function returns,
but as you said, it is not "clean", even if it is code-correct.

I'll rewrite the patch and I will send asap.

thanks
davide
