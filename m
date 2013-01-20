Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616Ab3ATVf1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 16:35:27 -0500
Received: from www.hansjkoch.de ([178.63.77.200]:36108 "EHLO www.hansjkoch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752503Ab3ATVf0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 16:35:26 -0500
X-Greylist: delayed 2008 seconds by postgrey-1.27 at vger.kernel.org; Sun, 20 Jan 2013 16:35:26 EST
Date: Sun, 20 Jan 2013 22:01:41 +0100
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Cong Ding <dinggnu@gmail.com>, "Hans J. Koch" <hjk@hansjkoch.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/1] uio.c: solve memory leak
Message-ID: <20130120210140.GA13035@local>
References: <1354210800-27230-1-git-send-email-dinggnu@gmail.com>
 <20121211012112.GA11273@local>
 <CAM3j68oNeb5HVYVHTSnQoiBHa7T4krkiDLy0dQkBZUd5BQgo2w@mail.gmail.com>
 <20130118220050.GA31286@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130118220050.GA31286@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2013 at 02:00:50PM -0800, Greg Kroah-Hartman wrote:
> On Fri, Jan 18, 2013 at 10:05:45PM +0100, Cong Ding wrote:
> > On Tue, Dec 11, 2012 at 2:21 AM, Hans J. Koch <hjk@hansjkoch.de> wrote:
> > > On Thu, Nov 29, 2012 at 05:40:00PM +0000, Cong Ding wrote:
> > >> In version 1, I forgot to modify the same bug in the first loop.
> > >>
> > >> we have to call kobject_put() to clean up the kobject after function
> > >> kobject_init(), kobject_add(), or kobject_uevent() is called.
> > >>
> > >> Signed-off-by: Cong Ding <dinggnu@gmail.com>
> > >
> > > Signed-off-by: "Hans J. Koch" <hjk@hansjkoch.de>
> > 
> > Hi Greg, is this patch stil in the queue?
> 
> Hans is queueing up UIO patches to send to me, I'm waiting for him to
> send them as I don't have any in my trees.

I'll set that up tonight or tomorrow. Sorry, I was delayed by illness
and a lot of other work.

Thanks,
Hans

> 
> thanks,
> 
> greg k-h
> 
