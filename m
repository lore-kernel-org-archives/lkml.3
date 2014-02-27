Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752337AbaB0TFg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 14:05:36 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:37064 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941AbaB0TFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 14:05:33 -0500
Date: Thu, 27 Feb 2014 11:07:10 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Matthew Garrett <matthew.garrett@nebula.com>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        James Morris <jmorris@namei.org>,
        linux-security-module <linux-security-module@vger.kernel.org>
Subject: Re: Trusted kernel patchset for Secure Boot lockdown
Message-ID: <20140227190710.GA4755@kroah.com>
References: <1393445473-15068-1-git-send-email-matthew.garrett@nebula.com>
 <CA+5PVA4RSh3hzJxEjpzHPj8w3uPoEzfg7ySWjB=6RUhAKJTudQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+5PVA4RSh3hzJxEjpzHPj8w3uPoEzfg7ySWjB=6RUhAKJTudQ@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 01:04:34PM -0500, Josh Boyer wrote:
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

What other patches depend on this series?  Why aren't they also in this
series?

thanks,

greg k-h
