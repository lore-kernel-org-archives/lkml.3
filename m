Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935745Ab3DJU7a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 16:59:30 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:42364 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760011Ab3DJU73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 16:59:29 -0400
Date: Wed, 10 Apr 2013 22:59:26 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?iso-8859-1?Q?P=E1draig?= Brady <P@draigBrady.com>
Subject: Re: mfd: Core driver for Winbond chips
Message-ID: <20130410205926.GB14155@spo001.leaseweb.com>
References: <1362957300-18223-1-git-send-email-linux@roeck-us.net> <20130322205258.GE7867@spo001.leaseweb.com> <20130323002810.GA26245@roeck-us.net> <20130323174914.GA21563@roeck-us.net> <20130409093700.GM24058@zurbaran> <20130409113639.GA8731@roeck-us.net> <20130409114544.GD7867@spo001.leaseweb.com> <20130409161838.GB27050@roeck-us.net> <20130409173115.GF7867@spo001.leaseweb.com> <20130410003632.GA25712@roeck-us.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130410003632.GA25712@roeck-us.net>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,

> > I looked at commit 8b6d043b7ee2d1b819dc833d677ea2aead71a0c0 (which implements
> > request_muxed_region). You indeed need some extra code for loading the lowl-level
> > mfd driver. So I am also in favour of the exported function.
> > 
> So which way should we go ? Take your driver as a starting point or mine ?
> 
> One thing I'll want to add is support for both superio regions, as I have a use
> case for it.

I'll come back on this tomorrow. It's going to be a merge of your and my code anyway.

I agree it would be nice to add also hwmon + wdog support in it from the start.

Kind regards,
Wim.

