Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752407AbaGPUah (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 16:30:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54308 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404AbaGPUaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 16:30:35 -0400
Date: Wed, 16 Jul 2014 13:30:11 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Kiran Padwal <kiran.padwal21@gmail.com>
Cc: devel@driverdev.osuosl.org, rusty@rustcorp.com.au, gulsah.1004@gmail.com,
        wkang77@gmail.com, peter.p.waskiewicz.jr@intel.com,
        valentina.manea.m@gmail.com, linux-kernel@vger.kernel.org,
        rashika.kheria@gmail.com, kiran.padwal@gmail.com
Subject: Re: [PATCH] Staging: gdm724x: fix missing blank line after variable
 declaration
Message-ID: <20140716203011.GA22844@kroah.com>
References: <1405509923-29422-1-git-send-email-kiran.padwal21@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405509923-29422-1-git-send-email-kiran.padwal21@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2014 at 04:55:23PM +0530, Kiran Padwal wrote:
> From: Kiran Padwal <kiran.padwal@gmail.com>
> 
> Checkpatch fix - Add missing blank line after variable declaration
> 
> Signed-off-by:Kiran Padwal <kiran.padwal21@gmail.com>

Minor nit, you need a ' ' after the ':'.

Also, you sent me two different patches, with the same Subject: line.
So I can't apply either of them, sorry.  Please resend both of them with
better subject lines (hint, put the filename in the subject: that would
fix this...)

thanks,

greg k-h
