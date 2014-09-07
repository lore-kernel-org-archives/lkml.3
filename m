Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750959AbaIGElO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 00:41:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49627 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708AbaIGElN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 00:41:13 -0400
Date: Sat, 6 Sep 2014 21:40:26 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: anicoara <anicoara@uwaterloo.ca>
Cc: shigekatsu.tateno@atmel.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, adi.nicoara88@gmail.com
Subject: Re: [PATCH] staging: ozwpan: Fix coding style warnings
Message-ID: <20140907044026.GA21688@kroah.com>
References: <20140906020823.GA9645@uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140906020823.GA9645@uwaterloo.ca>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 05, 2014 at 10:08:23PM -0400, anicoara wrote:
> The warnings addressed:
> 1. Missing a blank line after declarations.
> 2. else is not generally useful after a break or return

Please break this up into 2 patches, each patch should only do one thing
at a time.

thanks,

greg k-h
