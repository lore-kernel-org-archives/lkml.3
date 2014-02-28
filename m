Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752354AbaB1Cyv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 21:54:51 -0500
Received: from tundra.namei.org ([65.99.196.166]:60678 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750999AbaB1Cyu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 21:54:50 -0500
Date: Fri, 28 Feb 2014 14:03:04 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Josh Boyer <jwboyer@fedoraproject.org>
cc: Matthew Garrett <matthew.garrett@nebula.com>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Greg KH <gregkh@linuxfoundation.org>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>
Subject: Re: Trusted kernel patchset for Secure Boot lockdown
In-Reply-To: <CA+5PVA4RSh3hzJxEjpzHPj8w3uPoEzfg7ySWjB=6RUhAKJTudQ@mail.gmail.com>
Message-ID: <alpine.LRH.2.02.1402281402090.26521@tundra.namei.org>
References: <1393445473-15068-1-git-send-email-matthew.garrett@nebula.com> <CA+5PVA4RSh3hzJxEjpzHPj8w3uPoEzfg7ySWjB=6RUhAKJTudQ@mail.gmail.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Feb 2014, Josh Boyer wrote:

> On Wed, Feb 26, 2014 at 3:11 PM, Matthew Garrett
> <matthew.garrett@nebula.com> wrote:
> > The conclusion we came to at Plumbers was that this patchset was basically
> > fine but that Linus hated the name "securelevel" more than I hate pickled
> > herring, so after thinking about this for a few months I've come up with
> > "Trusted Kernel". This flag indicates that the kernel is, via some
> > external mechanism, trusted and should behave that way. If firmware has
> > some way to verify the kernel, it can pass that information on. If userspace
> > has some way to verify the kernel, it can set the flag itself. However,
> > userspace should not attempt to use the flag as a means to verify that the
> > kernel was trusted - untrusted userspace could have set it on an untrusted
> > kernel, but by the same metric an untrusted kernel could just set it itself.
> 
> FWIW, I've been running a kernel using this patchset in place of the
> patchset Fedora typically carries for this purpose for a bit.  Things
> appear to be working as expected and the protections remain the same.
> 
> It would be really nice to get this set of patches in so some of the
> other patches that depend on them can start being pushed as well.

Ok, which tree should take this?  I'm happy to, although most of it is 
outside security/ .



-- 
James Morris
<jmorris@namei.org>
