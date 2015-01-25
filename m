Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322AbbAYQWn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 11:22:43 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54686 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753816AbbAYQP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 11:15:28 -0500
Date: Sun, 25 Jan 2015 19:44:12 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: MariamMohamedFawzy <maryammohamed61@gmail.com>
Cc: devel@driverdev.osuosl.org, forest@alittletooquiet.net, tvboxspy@gmail.com,
        gclement@baobob.org, guido@vanguardiasur.com.ar,
        veronicca114@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: vt6655: fix that open brace { should be on the
 previous line
Message-ID: <20150125114412.GA12735@kroah.com>
References: <20150121100110.GA2652@mariam-VirtualBox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150121100110.GA2652@mariam-VirtualBox>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015 at 12:01:10PM +0200, MariamMohamedFawzy wrote:
> This patch fixes the following checkpatch.pl error:
> fix that open brace { should be on the previous line
> 
> Signed-off-by: MariamMohamedFawzy <maryammohamed61@gmail.com>

Please use the name you use to sign a legal document (odds are there
should be a space somewhere here, right?)  Same goes for your "From:"
line too.

thanks,

greg k-h
