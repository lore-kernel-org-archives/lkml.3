Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758023Ab3GWUuw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 16:50:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40089 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757667Ab3GWUuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 16:50:51 -0400
Date: Tue, 23 Jul 2013 13:50:50 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Peng Tao <bergwolf@gmail.com>, linux-kernel@vger.kernel.org,
        Paul Bolle <pebolle@tiscali.nl>,
        Andreas Dilger <andreas.dilger@intel.com>, Peng Tao <tao.peng@emc.com>
Subject: Re: [PATCH] staging/lustre: fix Kconfig bool defaults
Message-ID: <20130723205050.GA10282@kroah.com>
References: <1374511290-4883-1-git-send-email-bergwolf@gmail.com>
 <20130722173332.GA14140@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130722173332.GA14140@merkur.ravnborg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 22, 2013 at 07:33:33PM +0200, Sam Ravnborg wrote:
> On Tue, Jul 23, 2013 at 12:41:30AM +0800, Peng Tao wrote:
> > Should be y/n instead of true/false...
> > 
> > Reported-by: Paul Bolle <pebolle@tiscali.nl>
> > Cc: Andreas Dilger <andreas.dilger@intel.com>
> > Signed-off-by: Peng Tao <tao.peng@emc.com>
> 
> default n is the default.
> So usually we advice to drop this.

I agree, just delete the lines, no need to be explicit with the default.

thanks,

greg k-h
