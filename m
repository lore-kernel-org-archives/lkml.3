Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759485AbaCTSOE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 14:14:04 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:43953 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759223AbaCTSOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 14:14:00 -0400
Date: Thu, 20 Mar 2014 18:13:21 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: "tytso@mit.edu" <tytso@mit.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "jwboyer@fedoraproject.org" <jwboyer@fedoraproject.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: Trusted kernel patchset for Secure Boot lockdown
Message-ID: <20140320181321.6b86a30c@alan.etchedpixels.co.uk>
In-Reply-To: <1395335525.16016.3.camel@x230>
References: <1394762250.6416.24.camel@x230.lan>
	<20140314122231.17b9ca8a@alan.etchedpixels.co.uk>
	<1394801518.6416.38.camel@x230.lan>
	<20140314170655.0ce398a3@alan.etchedpixels.co.uk>
	<1394820664.26846.18.camel@x230.mview.int.nebula.com>
	<20140314214806.54a3d031@alan.etchedpixels.co.uk>
	<1394834193.1286.11.camel@x230>
	<20140314220840.29a12171@alan.etchedpixels.co.uk>
	<20140314231832.GA653@thunk.org>
	<CAGXu5j+JXy4EbHxu+8twWo=3gqyLJ6hZGPbgsdf3t8YhUA-bWw@mail.gmail.com>
	<20140320145507.GB20618@thunk.org>
	<1395335525.16016.3.camel@x230>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Whether Microsoft would actually follow through on blacklisting their
> own signatures is obviously an unknown - they've told us they would, but
> commercial concerns etc who knows. They *will* blacklist our signatures.

I think that becomes an irrelevant debate. It's going to end up being
argued in a court by lawyers some day and its not software problem. One
day some bright spark from MS will decide to do things like enforce
patent disputes this way or commercial pressures will lead them to
try and find some other excuse to do it.

It's never going to be "secure", so they'll always be able to find an
excuse.

The functionality you have to disable is for the most part quite boring
for desktop users. Server may see it differently because you cripple a
lot of debugging work. OTOH many of them probably want to turn it on for
production boxes.

The main thing you lose are lots of module options, the ability to force
addresses for things like the serial port console (otherwise I can force
an address and root the kernel that way), mem=, custom ACPI tables and so
on.

It's the stuff that lets you get a box with crapware as firmware working
that's really hit.

Alan

