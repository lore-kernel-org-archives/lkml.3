Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754292AbaKSC0R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 21:26:17 -0500
Received: from gate.crashing.org ([63.228.1.57]:55423 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753643AbaKSC0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 21:26:16 -0500
Message-ID: <1416363953.5704.19.camel@kernel.crashing.org>
Subject: Re: [RFC] Add of_path property for all devices with a node
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <robherring2@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
Date: Wed, 19 Nov 2014 13:25:53 +1100
In-Reply-To: <CACxGe6vg8SxwCHZ8HxzLzimQOAf8Q81wd5eO=x2LavD4dv81Rw@mail.gmail.com>
References: <1415342031.4925.27.camel@kernel.crashing.org>
	 <1415342117.4925.29.camel@kernel.crashing.org>
	 <1415596626.5769.14.camel@kernel.crashing.org>
	 <CAL_JsqKG=vpeGKj3v-2VW9oGQsnmuYMHRfy6LuXDXE=ROjHT4w@mail.gmail.com>
	 <CACxGe6vg8SxwCHZ8HxzLzimQOAf8Q81wd5eO=x2LavD4dv81Rw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-11-18 at 15:18 +0000, Grant Likely wrote:
> >> So not much reactions here .. a bit more on IRC, where Olof
> suggested
> >> that rather than a file containing a path, we could use a symlink
> since
> >> the devtree is now in sysfs, so we can do relative links.
> >
> > +1 on this. That was part of the motivation to move DT into sysfs.
> >
> > Rob
> 
> I had a patch that did exactly that. I wonder what happened to it...
> 
> But regardless, as Frank said in his reply, this data is already in
> the uevent file for every device.

I sent a patch doing the symlink days ago.... I think it's still
valuable, the patch is triviall and the symlink is a lot easier to deal
with than parsing the uevent file.

Cheers,
Ben.


