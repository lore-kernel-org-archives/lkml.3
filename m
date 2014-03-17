Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588AbaCQVAU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 17:00:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48117 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456AbaCQVAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 17:00:17 -0400
Date: Mon, 17 Mar 2014 14:02:18 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Conrad Meyer <cemeyer@uw.edu>
Cc: Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Conrad Meyer <cse.cem@gmail.com>
Subject: Re: [PATCH 1/2] Staging: comedi: Fix if/else style in
 hwdrv_apci1500.c
Message-ID: <20140317210218.GA25142@kroah.com>
References: <1394382281-22712-1-git-send-email-cse.cem@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394382281-22712-1-git-send-email-cse.cem@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 09, 2014 at 09:24:40AM -0700, Conrad Meyer wrote:
> Also kill some useless comments while I was there, e.g.:
>   if (foo) {
>     ...
>   }  /* if (foo) */
> 
> With vim:
>   :%s/}\t\t*\/\*\s\s*\(if\|else\|for\|while\|switch\).*$/}/

Neither of these patches apply to my tree, can you redo them and resend?

thanks,

greg k-h
