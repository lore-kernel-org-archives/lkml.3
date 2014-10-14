Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932210AbaJNIqE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 04:46:04 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:43206 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754809AbaJNIqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 04:46:01 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Tue, 14 Oct 2014 10:48:15 +0200
From: Johan Hovold <johan@kernel.org>
To: tecfacet <tecfacet@yahoo.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: rotary encoder linux driver
Message-ID: <20141014084815.GC7958@localhost>
References: <1413163743.39490.YahooMailNeo@web160203.mail.bf1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413163743.39490.YahooMailNeo@web160203.mail.bf1.yahoo.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 12, 2014 at 06:29:03PM -0700, tecfacet wrote:
> Hello.
> 
> I am interested in the rotary encoder kernel driver.  I am very new to
> this linux kernel driver thing.  
> 
> How do I pass the gpio and interrupt stuff to the kernel module.. I
> think it is thru the rotary_encoder.h file.. am I correct?

That should be done through the device tree these days. The binding is
documented in

	Documentation/devicetree/bindings/input/rotary-encoder.txt

in the kernel source tree.

> How does the information about encoder position etc get back to my
> user space program?  How is debounce handled?
> I am a little confused.  Is there an example of a complete working
> implementation?  I need to figure this out for school.

Have a look at the evtest program for an example:

	http://cgit.freedesktop.org/~whot/evtest

Good luck,
Johan
