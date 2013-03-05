Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756303Ab3CEKEI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 05:04:08 -0500
Received: from mail-ee0-f47.google.com ([74.125.83.47]:35726 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756124Ab3CEKEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 05:04:04 -0500
Message-ID: <5135C311.1030702@suse.cz>
Date: Tue, 05 Mar 2013 11:04:01 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: jeffrey.t.kirsher@intel.com
CC: Bjorn Helgaas <bhelgaas@google.com>, Borislav Petkov <bp@alien8.de>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, lkml <linux-kernel@vger.kernel.org>,
        e1000-devel@lists.sourceforge.net,
        Bruce Allan <bruce.w.allan@intel.com>
Subject: Re: Uhhuh. NMI received for unknown reason 2c on CPU 0.
References: <20130129202848.GE25415@pd.tnic>  <3066730.6MVSAfNyye@vostro.rjw.lan> <20130131131034.GF4926@pd.tnic>  <2293454.v8QRHr8txR@vostro.rjw.lan> <20130203144656.GB5844@pd.tnic>  <20130214143905.GC5700@pd.tnic>  <CAErSpo6Mi31O1YA5PKnRjQMinB284Ag6PY8LuZpD0NwuZ6QZuw@mail.gmail.com>  <20130214191234.GH5700@pd.tnic> <511DF7B4.8060504@openvz.org>  <20130215091641.GA14387@pd.tnic> <20130304215056.GG22274@pd.tnic>  <CAErSpo7Fj3zOp0S9kFrZBCe5u9r6kJUNyx+parGfoq52gWD3XQ@mail.gmail.com>  <5135BDF9.3080102@suse.cz> <1362477679.8626.13.camel@jtkirshe-mobl>
In-Reply-To: <1362477679.8626.13.camel@jtkirshe-mobl>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 03/05/2013 11:01 AM, Jeff Kirsher wrote:
> On Tue, 2013-03-05 at 10:42 +0100, Jiri Slaby wrote:
>>> The e1000e changes didn't get merged, did they?  I don't see
>>> the following changes mentioned at
>>> https://lkml.org/lkml/2013/2/4/185 in 3.9-rc1:
>>> 
>>> e1000e: fix pci-device enable-counter balance e1000e: fix
>>> runtime power management transitions e1000e: fix accessing to
>>> suspended device
>> 
>> You're right. They are not even in -next :(.
>> 
> 
> I have them in my queue for net, so I should be pushing them later
> this week once validation has a chance to look at them.

Yeah, I've just noticed that here
https://lkml.org/lkml/2013/2/25/3

Thanks a lot.

- -- 
js
suse labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJRNcMQAAoJEL0lsQQGtHBJ+ZkP/3AokrLy82YOmecMvuFssino
jpS9MSjr3Fq8H6WvDmqyhFkKiL8wW0liQU1ZHU8csAFOmTCYUUhrN7QyjZZLt3Ek
QeUhPCi40uaL+jjfDh2TFy6dI/kvtiLxwUfQ4YcGOnNoJSMsN14E4PFiwWcQ/vfX
rOsw9z+MkqJ4je2ZuDFBxZBcUYgdb1Mlrk7gPTVwADz+DnE3PN7DKIYWy3grI5/U
uI9QkyESv4YEdpBBEphqdK3TNWWZS4QyiOq2glNgllnoksybI1JnYAWt+O2Khcef
Os9O/ccZcUiQK6K6HvEYvJvp9eGhPNVt7Fyr+JBV3bzKoPlIcHOIgktahuisUuiZ
zZsxshj3pFYBhCGlGkjbkMkB74hkgenJoT9e36JMPtov00E11B+DazqGodZm1jto
e70821Y6MQ5gavTZrrdcmzJmzSwEsdww7ALs+FCTIBpc8Re0MrZMIp+XrTFnue2L
aA23fYLu6/1uqd11PGNb+82P5s6dYpFCR9NHV29TPuXk50yH60z1Me8n3wMCzm8Y
rIvrk6Xd3XATqepM6qG6O/cDPpvxo9itZldKBvi1SD088n3qEUdJWmLRzpaxisrt
v0pCuUNx+pZE6gTE+tsxbv2k5d0RtNYPsnDJrds7EKMyhIwam7NDJcX490tu9pU8
VLndALzYj0O07N4wCQP1
=MGO1
-----END PGP SIGNATURE-----
