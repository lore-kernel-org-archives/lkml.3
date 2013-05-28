Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266Ab3E1T1J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 15:27:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60133 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655Ab3E1T1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 15:27:07 -0400
Date: Wed, 29 May 2013 04:27:21 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: Daniel Mack <zonque@gmail.com>
Cc: Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org,
        ming.lei@canonical.com
Subject: Re: [PATCH] firmware: move EXPORT_SYMBOL annotations
Message-ID: <20130528192721.GA2498@kroah.com>
References: <1369340238-8631-1-git-send-email-zonque@gmail.com>
 <s5h38t8stua.wl%tiwai@suse.de>
 <51A4F7D5.9070107@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51A4F7D5.9070107@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 28, 2013 at 08:30:45PM +0200, Daniel Mack wrote:
> On 27.05.2013 10:35, Takashi Iwai wrote:
> > At Thu, 23 May 2013 22:17:18 +0200,
> > Daniel Mack wrote:
> >>
> >> Move EXPORT_SYMBOL annotations so they follow immediately after the
> >> closing function brace line.
> >>
> >> Signed-off-by: Daniel Mack <zonque@gmail.com>
> > 
> >   Acked-by: Takashi Iwai <tiwai@suse.de>
> 
> Thanks. Greg, could you take this through your tree?

Yes, will do, give me some time to catch up on patches after returning
from LinuxCon Japan this week.

greg k-h
