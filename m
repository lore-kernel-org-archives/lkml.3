Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752911Ab3GBOuq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 10:50:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56087 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165Ab3GBOup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 10:50:45 -0400
Date: Tue, 2 Jul 2013 07:51:35 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Mark Galeck <mark_galeck@pacbell.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: is it desirable to improve the build system?
Message-ID: <20130702145135.GA975@kroah.com>
References: <1372723921.53875.YahooMailNeo@web182202.mail.bf1.yahoo.com>
 <20130702044516.GA31484@kroah.com>
 <1372754805.73620.YahooMailNeo@web182206.mail.bf1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1372754805.73620.YahooMailNeo@web182206.mail.bf1.yahoo.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 02, 2013 at 01:46:45AM -0700, Mark Galeck wrote:
> >> Linux kernel build, while correct, is somewhat slow, and the sources
> 
> >> could be more readable.
> 
> Greg wrote:
> >How is it "slow"?  
> 
> Well, the proportion of time spent by the CPU cores on activities
> other than compiling seemed high.

Really?  What is that proportion?

> >What "sources" are you referring to as being not readable?
> 
> Not "not readable at all", just "could be made more readable" - the
> main Makefile and other main Make files; it seemed that one reason,
> IMHO, was not enough comments. 

Everyone always wants more comments :)

Have you read the documentation about the build system that we have in
the kernel Documentation/ directory?

There is also a mailing list just for the build system as well, see the
MAINTAINERS file for details.

greg k-h
