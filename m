Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754368Ab3DFQ5h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 12:57:37 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:58773 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723Ab3DFQ5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 12:57:36 -0400
Date: Sat, 6 Apr 2013 09:57:33 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Sebastian Wankerl <sisewank@cip.cs.fau.de>
Cc: rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
        Philip Kranz <philip.kranz@googlemail.com>
Subject: Re: [PATCH] Make information about modules available to kgdb.
Message-ID: <20130406165733.GA29794@kroah.com>
References: <1365253255-14154-1-git-send-email-sisewank@cip.cs.fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365253255-14154-1-git-send-email-sisewank@cip.cs.fau.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 06, 2013 at 03:00:55PM +0200, Sebastian Wankerl wrote:
> From: Philip Kranz <philip.kranz@googlemail.com>
> 
> To be able to properly debug kernel modules kgbd needs to know all SHF_ALLOC
> sections of the module. This patch add an array of those sections to struct
> module. One cannot use sysfs since it does not contain all sections needed.

Why not just add those sections to sysfs so that everyone can see them?

thanks,

greg k-h
