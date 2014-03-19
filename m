Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752369AbaCSRuC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 13:50:02 -0400
Received: from albireo.enyo.de ([46.237.207.196]:49603 "EHLO albireo.enyo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750742AbaCSRt6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 13:49:58 -0400
X-Greylist: delayed 463 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Mar 2014 13:49:58 EDT
From: Florian Weimer <fw@deneb.enyo.de>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jmorris\@namei.org" <jmorris@namei.org>,
        "keescook\@chromium.org" <keescook@chromium.org>,
        "linux-security-module\@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>,
        "akpm\@linux-foundation.org" <akpm@linux-foundation.org>,
        "hpa\@zytor.com" <hpa@zytor.com>,
        "jwboyer\@fedoraproject.org" <jwboyer@fedoraproject.org>,
        "linux-efi\@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "gregkh\@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: Trusted kernel patchset for Secure Boot lockdown
References: <1394746248.27846.3.camel@x230>
	<20140313232140.03bdaac3@alan.etchedpixels.co.uk>
	<1394762250.6416.24.camel@x230.lan>
	<20140314122231.17b9ca8a@alan.etchedpixels.co.uk>
	<1394801518.6416.38.camel@x230.lan>
	<20140314170655.0ce398a3@alan.etchedpixels.co.uk>
	<1394820664.26846.18.camel@x230.mview.int.nebula.com>
	<20140314214806.54a3d031@alan.etchedpixels.co.uk>
	<1394834193.1286.11.camel@x230>
	<20140314220840.29a12171@alan.etchedpixels.co.uk>
	<20140314231832.GA653@thunk.org>
Date: Wed, 19 Mar 2014 18:49:49 +0100
In-Reply-To: <20140314231832.GA653@thunk.org> (Theodore Ts'o's message of
	"Fri, 14 Mar 2014 19:18:32 -0400")
Message-ID: <87eh1y84ea.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Theodore Ts'o:

> Right now, even though Lenovo laptops are shipping with Windows
> 8. UEFI secure boot is not made mandatory (although it is on enough to
> brick the laptop when it runs into bugs wwith the UEFI BIOS code,
> sigh).  But sooner or later, UEFI secure boot will be on by default,
> and then if Linux distros don't have kernels where the installer can
> be run without needing to twiddle BIOS settings, it might make it
> harder for the "Year of the Desktop" to come about.

Windows 8 logo devices already enable Secure Boot by default.

One aspect which makes all this really tricky is that Microsoft is
watching what we're doing and will keep raising the bar, probably not
with the intent to lock us out completely, but sufficiently high to
make things quite annoying.  For example, any certificate-signing
certificate in the boot process needs to be an EV CA certificate,
which comes with fairly stringent requirements that are quite costly
to implement.

So any restrictions we implement as a good-will gesture will
eventually come back to haunt us.
