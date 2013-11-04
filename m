Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772Ab3KDO4n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 09:56:43 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:46694 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418Ab3KDO4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 09:56:41 -0500
Date: Mon, 4 Nov 2013 06:56:26 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Remove h8300 platform support
Message-ID: <20131104145626.GA7651@roeck-us.net>
References: <20131104005707.GA13325@roeck-us.net>
 <alpine.DEB.2.02.1311040924290.20164@ayla.of.borg>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.DEB.2.02.1311040924290.20164@ayla.of.borg>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 04, 2013 at 09:27:27AM +0100, Geert Uytterhoeven wrote:
> 	Hi Günther,
> 
> On Sun, 3 Nov 2013, Guenter Roeck wrote:
> >       Drop MAINTAINERS entry for H8/300
> 
> Can you please add the following patch, or fold it into the above one?
> 
I added it. I did not move the label yet, though; I'll wait until mid next week
to see if there is additional feedback, and then send an updated pull request
to Linus.

Thanks,
Guenter
