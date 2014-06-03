Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933987AbaFCVKn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 17:10:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53366 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932907AbaFCVKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 17:10:42 -0400
Date: Tue, 3 Jun 2014 14:14:20 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Olof Johansson <olof@lixom.net>
Cc: Kumar Gala <galak@codeaurora.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] tty: serial: msm: Fix section mismatch warning
Message-ID: <20140603211420.GA1192@kroah.com>
References: <1401826402-1079-1-git-send-email-galak@codeaurora.org>
 <20140603203318.GB6582@kroah.com>
 <CAOesGMh5knixNp+dgWnQu5M00N4ZMm10PoBh3YVTquryfRh-cw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOesGMh5knixNp+dgWnQu5M00N4ZMm10PoBh3YVTquryfRh-cw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2014 at 02:04:43PM -0700, Olof Johansson wrote:
> On Tue, Jun 3, 2014 at 1:33 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > On Tue, Jun 03, 2014 at 03:13:22PM -0500, Kumar Gala wrote:
> >> WARNING: drivers/tty/built-in.o(.data+0x3544): Section mismatch in
> >> reference from the variable msm_platform_driver to the function
> >> .init.text:msm_serial_probe()
> >> The variable msm_platform_driver references
> >> the function __init msm_serial_probe()
> >> If the reference is valid then annotate the
> >> variable with __init* or __refdata (see linux/init.h) or name the variable:
> >> *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console
> >
> > Where is this mismatch showing up at?  3.15-rc8, 3.16-rc1?  Somewhere
> > older or else?
> 
> Linus' next branch, it was merged through arm-soc. I didn't notice it
> in time to fix it before we sent to Linus. :(

Ok, do you want to take this patch then?  I don't mind taking it through
my tree, but it will have to wait until after 3.16-rc1 is out.  It's up
to you.

thanks,

greg k-h
