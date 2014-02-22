Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751708AbaBVQrf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 11:47:35 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35515 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091AbaBVQre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 11:47:34 -0500
Date: Sat, 22 Feb 2014 08:50:17 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: "Gideon D'souza" <gidisrael@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kernel-mentors@selenic.com
Subject: Re: Newbie: When does the merge window come by?
Message-ID: <20140222165017.GA25720@kroah.com>
References: <CAPNrq4xFXjN5AR=J9pdoE+uzHwSiZ_aM1G90jS17-PmfojTDGA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPNrq4xFXjN5AR=J9pdoE+uzHwSiZ_aM1G90jS17-PmfojTDGA@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 22, 2014 at 01:56:30PM +0530, Gideon D'souza wrote:
> Hi All,
> 
> I apologize for the ignorance but I haven't been able to tell when the
> Linus' merge window is open.

Unless you are a subsystem maintainer, the merge window shouldn't matter
for you.

> >From this page:
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/
> 
> Questions I have:
> > I notice that there is a 3.14-rc3 tag so I'm assuming that is the latest/current version?
> > After the last rc is there some announcement that the merge window is open?
> > During the merge window (of 1-2 weeks) stuff for various subsystems and linux-next are sent in correct?

Have you read Documentation/development-process/ ?  The files there
should explain this.

thanks,

greg k-h
