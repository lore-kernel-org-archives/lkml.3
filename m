Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758978Ab3HMR7v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 13:59:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38833 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758392Ab3HMR7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 13:59:50 -0400
Date: Tue, 13 Aug 2013 10:59:49 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Subject: Re: s2ram + X11 broken between 3.10.5 and 3.10.6 (i915)
Message-ID: <20130813175949.GE7336@kroah.com>
References: <520A5822.4080804@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <520A5822.4080804@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 13, 2013 at 06:00:34PM +0200, Toralf Förster wrote:
> At a ThinkPad T420 w/ a 32 bit stable Gentoo Linux and a started X11
> server an attempt to s2ram results in a blank scree, a gloomy blinking
> power button and no syslog message or something helpful . If the system
> is booting w/o X11 then s2ram works.
> 
> s2ram in 3.10.5 works - and FWIW in 3.11-rc5 s2ram is fine.

Can you run 'git bisect' to track it down to the offending patch?

Also, does 3.11-rc5 work for you?

thanks,

greg k-h
