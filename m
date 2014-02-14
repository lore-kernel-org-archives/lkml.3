Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291AbaBNRPu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 12:15:50 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:43664 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644AbaBNRPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 12:15:49 -0500
Date: Fri, 14 Feb 2014 09:17:08 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: r8188eu: Remove dead code
Message-ID: <20140214171708.GA26304@kroah.com>
References: <1392292818.14949.5.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392292818.14949.5.camel@x220>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 13, 2014 at 01:00:18PM +0100, Paul Bolle wrote:
> There are a few lines in this driver that depend on a macro
> CONFIG_BT_COEXIST. But there's no Kconfig symbol of that name nor is
> there a preprocessor define for that string. So remove these lines.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Entirely untested.
> 
> Fun fact: two years ago, code depending on the same undefined macro was
> removed from rtl8192cu, see commit 9ef11f7b34c0 ("rtl8192cu: Remove dead
> code never selected"). I wonder where this macro originated.

It comes from the stand-alone version of this driver, and the config
options that it "provides" when building.  So expect it to constantly
show up until this company stops relying on their internal tree...

thanks,

greg k-h
