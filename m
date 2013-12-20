Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756530Ab3LTRBv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 12:01:51 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53105 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754955Ab3LTRBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 12:01:50 -0500
Date: Fri, 20 Dec 2013 09:01:59 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Gokulnath A <gokul.linux@gmail.com>
Cc: Michael Hoefler <michael.hoefler@studium.uni-erlangen.de>,
        "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
        linux-kernel@i4.cs.fau.de, Christoph Kohl <christoph.kohl@t-online.de>,
        open list <linux-kernel@vger.kernel.org>,
        Rupert Muchembled <rupert@rmuch.net>
Subject: Re: [PATCHv2 1/3] silicom: fix whitespace issues in bypass.c
Message-ID: <20131220170159.GA15634@kroah.com>
References: <1387547475-7135-1-git-send-email-michael.hoefler@studium.uni-erlangen.de>
 <1387547475-7135-2-git-send-email-michael.hoefler@studium.uni-erlangen.de>
 <CADKvho6HF9A6agDXwrg7UPcOS0YQh3bPmGzPjOAEO8tZ8cveTw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADKvho6HF9A6agDXwrg7UPcOS0YQh3bPmGzPjOAEO8tZ8cveTw@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 20, 2013 at 08:36:48PM +0530, Gokulnath A wrote:
> Hello Michael,
> 
> On Fri, Dec 20, 2013 at 7:21 PM, Michael Hoefler
> <michael.hoefler@studium.uni-erlangen.de> wrote:
> > This patch addresses several problems in bypass.c found by checkpatch.
> > Furthermore it removes/adds some empty lines to make the code more readable.
> >
> > The following problems are fixed:
> >  - line over 80 characters
> >  - space after logical operator !
> >  - spaces instead of tabs
> >  - missing empty line after local declarations
> >  - empty line after {
> >
> 
> Please do one thing per patch, As Greg suggested for me in previous mail
> conversations. Here you could have at least 3 or 4 patches.
> For example, first patch would be a fix for line over 80 characters,
> followed by the other problems as mentioned above by you.

Nah, all of these are affecting the same macros, so it's ok, I'll take
it as-is.

thanks,

greg k-h
