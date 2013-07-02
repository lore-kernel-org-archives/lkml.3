Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932241Ab3GBJqX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 05:46:23 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:60902 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753546Ab3GBJqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 05:46:22 -0400
Date: Tue, 2 Jul 2013 11:46:06 +0200
From: Johan Hovold <jhovold@gmail.com>
To: Anders Hammarquist <iko@iko.pp.se>
Cc: Johan Hovold <jhovold@gmail.com>, Greg KH <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 0/2] *** SUBJECT HERE ***
Message-ID: <20130702094606.GA30165@localhost>
References: <20130619225315.GB12282@kroah.com>
 <201306212308.r5LN8C7M020720@eskarina.iko.pp.se>
 <20130621235603.GA1603@kroah.com>
 <201306221854.r5MIshv5013882@eskarina.iko.pp.se>
 <20130625233911.GA1087@kroah.com>
 <201306260829.r5Q8Txm5003881@eskarina.iko.pp.se>
 <20130626103924.GA30828@localhost>
 <201306272150.r5RLoq2u006119@eskarina.iko.pp.se>
 <20130628102333.GA13241@localhost>
 <201307012322.r61NM1vv019204@eskarina.iko.pp.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201307012322.r61NM1vv019204@eskarina.iko.pp.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 02, 2013 at 01:22:01AM +0200, Anders Hammarquist wrote:
> In a message of Fri, 28 Jun 2013 12:23:33 +0200, Johan Hovold writes:
> >> I did a quick check of adding the device id though sysfs, and although
> >> it partly works, it doesn't find the correct firmware (it ends up trying
> >> to load 5052 firmware for a 3410 device. Looking at the code it seems
> >> (struct ti_device) td_is_3410 isn't set properly.)
> >
> >Turns out that the drivers device-type detection has never worked with
> >the dynamic id interface (all devices were detected as 2-port devices).
> >
> >I'm responding to this mail with a fix. Care to give it a try?
> 
> Yes, this works fine. 

Thanks for testing.

Johan
