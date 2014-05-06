Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757952AbaEFQDR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 12:03:17 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:63973 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755148AbaEFQDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 12:03:16 -0400
Message-ID: <1399392184.3691.15.camel@ltli10.sensirion.lokal>
Subject: Re: [RFC][PATCH v2] hwmon: add support for Sensirion SHTC1 sensor
From: Tomas Pop <tomas.pop.mff@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: "jdelvare@suse.de" <jdelvare@suse.de>, lm-sensors@lm-sensors.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        johannes.winkelmann@sensirion.com
Date: Tue, 06 May 2014 09:03:04 -0700
In-Reply-To: <536853C0.8020406@roeck-us.net>
References: <1398985530.17142.15.camel@ltli10.sensirion.lokal>
			 <5362FDA9.8080300@roeck-us.net>
			 <1399064369.3019.83.camel@ltli10.sensirion.lokal>
			 <20140502231528.GA5157@roeck-us.net>
		 <1399338214.24993.10.camel@ltli10.sensirion.lokal>
		 <53683D38.7010904@roeck-us.net>
	 <1399341707.24993.20.camel@ltli10.sensirion.lokal>
	 <536853C0.8020406@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gunter,

Yes, that's exactly the idea - we would like to provide basic support
for a few low-cost boards as a starting point for anybody who is
interested in the sensor. Previously I was testing mostly on some
Android devices (kernel 3.4), and it seems, that a lot of thinks changed
in since version 3.4 :-)

I will send in few days a tested version..

Thanks,
Tomas

 

On Mon, 2014-05-05 at 20:15 -0700, Guenter Roeck wrote:
> On 05/05/2014 07:01 PM, Tomas Pop wrote:
> > Hi Guenter,
> >
> > Thanks a lot for comments and patience - with the testing you are right,
> > I'm still waiting for board, where I will be able to run latest kernel
> > and have the chip wired in - sorry for this...
> >
> 
> No problem. Please make sure that the driver has been tested with the real
> chip before the final submission.
> 
> Just wondering - don't you have a little test board to make the i2c pins
> more readily available ? Such a board could be connected to any i2c adapter
> and/or to a mainboard which exposes i2c pins. That is usually how I test
> the various sensors I am working with. You could even sell that to the
> hobbyists :-).
> 
> Thanks,
> Guenter
> 


