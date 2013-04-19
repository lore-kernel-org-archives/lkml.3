Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563Ab3DSSdA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 14:33:00 -0400
Received: from sauhun.de ([89.238.76.85]:54596 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753171Ab3DSSc7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 14:32:59 -0400
Date: Fri, 19 Apr 2013 20:32:58 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: EUNBONG SONG <eunb.song@samsung.com>
Cc: "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Re: [PATCH]  I2C: Change the value of octeon i2c adapter timeout
 value
Message-ID: <20130419183258.GB3702@the-dreams.de>
References: <33288064.110491366362833968.JavaMail.weblogic@epv6ml06>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <33288064.110491366362833968.JavaMail.weblogic@epv6ml06>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 19, 2013 at 09:13:54AM +0000, EUNBONG SONG wrote:
> 
> 
> On Fri, Apr 19, 2013 at 12:01:04AM +0000, EUNBONG SONG wrote:
> >> 
> >>  I think HZ/50 is better than 2 for adapter timeout.
> 
> > Basically OK. But why HZ/50? Most drivers use HZ.
> 
> Actually, I just translated 2 jiffies because HZ is 100 in default cavium config. 
> You can find that in "arch/mips/configs/cavium_octeon_defconfig". 
> And i have been using this value over 1 year in octeon board without problem.

Have you been writing to EEPROMS? Their erase/write cycle might be
longer. But I am not forcing you to change the value, just giving some
suggestions.

