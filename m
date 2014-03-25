Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525AbaCYSQK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 14:16:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46116 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752699AbaCYSQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 14:16:07 -0400
Date: Tue, 25 Mar 2014 11:17:49 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8188eu: remove spaces, correct counts to
 unbreak P2P ioctls
Message-ID: <20140325181749.GE3233@kroah.com>
References: <20140325175939.GC17209@kaos.lebenslange-mailadresse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140325175939.GC17209@kaos.lebenslange-mailadresse.de>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2014 at 05:59:39PM +0000, Wilfried Klaebe wrote:
> staging: rtl8188eu: remove spaces, correct counts to unbreak P2P ioctls
> 
> It looks like someone did a search-and-replace on that driver, putting
> spaces before "=" characters, without checking this is OK everywhere.
> Also, in some places, there's memcpm()s/strncmp()s checking for some
> different length than the fixed string argument.
> 
> These things result in code not working as intended. Fix that.

What code is parsing string output from the kernel?

greg k-h
