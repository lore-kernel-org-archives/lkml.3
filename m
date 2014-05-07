Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752348AbaEGWgv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 18:36:51 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:40834 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950AbaEGWgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 18:36:49 -0400
Date: Wed, 7 May 2014 15:36:40 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Tomas Pop <tomas.pop.mff@gmail.com>
Cc: "jdelvare@suse.de" <jdelvare@suse.de>, lm-sensors@lm-sensors.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        johannes.winkelmann@sensirion.com
Subject: Re: [RFC][PATCH v2] hwmon: add support for Sensirion SHTC1 sensor
Message-ID: <20140507223640.GA12865@roeck-us.net>
References: <5362FDA9.8080300@roeck-us.net>
 <1399064369.3019.83.camel@ltli10.sensirion.lokal>
 <20140502231528.GA5157@roeck-us.net>
 <1399338214.24993.10.camel@ltli10.sensirion.lokal>
 <53683D38.7010904@roeck-us.net>
 <1399341707.24993.20.camel@ltli10.sensirion.lokal>
 <536853C0.8020406@roeck-us.net>
 <1399392184.3691.15.camel@ltli10.sensirion.lokal>
 <53699EB1.6040007@roeck-us.net>
 <1399481886.452.11.camel@ltli10.sensirion.lokal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399481886.452.11.camel@ltli10.sensirion.lokal>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2014 at 09:58:06AM -0700, Tomas Pop wrote:
> On Die, 2014-05-06 at 19:47 -0700, Guenter Roeck wrote:
> > Great. Unfortunately those chips are so small that they don't fit on
> > my test boards, or I would have ordered some myself. I am looking forward
> > to see those boards available for order somewhere ... hopefully at a lower
> > price point than your evaluation boards ;-).
> > 
> > Thanks,
> > Guenter
> > 
> 
> Hi Guenter, 
> I think, it would be great if somebody independent like you can play 
> a bit with the sensor, before the patch will be merged. I will try to
> find out, what I could do about this ;-)
> 
I for sure wouldn't mind if an evaluation / test board finds its way to me.
Note that all I would need is a little board with power and i2c connectors
similar to [1] or [2].

Guenter

[1] https://www.sparkfun.com/products/11931
[2] https://www.sparkfun.com/products/8257
