Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755112Ab3ARWAz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 17:00:55 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:37442 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881Ab3ARWAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 17:00:54 -0500
Date: Fri, 18 Jan 2013 14:00:50 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Cong Ding <dinggnu@gmail.com>
Cc: "Hans J. Koch" <hjk@hansjkoch.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/1] uio.c: solve memory leak
Message-ID: <20130118220050.GA31286@kroah.com>
References: <1354210800-27230-1-git-send-email-dinggnu@gmail.com>
 <20121211012112.GA11273@local>
 <CAM3j68oNeb5HVYVHTSnQoiBHa7T4krkiDLy0dQkBZUd5BQgo2w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM3j68oNeb5HVYVHTSnQoiBHa7T4krkiDLy0dQkBZUd5BQgo2w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2013 at 10:05:45PM +0100, Cong Ding wrote:
> On Tue, Dec 11, 2012 at 2:21 AM, Hans J. Koch <hjk@hansjkoch.de> wrote:
> > On Thu, Nov 29, 2012 at 05:40:00PM +0000, Cong Ding wrote:
> >> In version 1, I forgot to modify the same bug in the first loop.
> >>
> >> we have to call kobject_put() to clean up the kobject after function
> >> kobject_init(), kobject_add(), or kobject_uevent() is called.
> >>
> >> Signed-off-by: Cong Ding <dinggnu@gmail.com>
> >
> > Signed-off-by: "Hans J. Koch" <hjk@hansjkoch.de>
> 
> Hi Greg, is this patch stil in the queue?

Hans is queueing up UIO patches to send to me, I'm waiting for him to
send them as I don't have any in my trees.

thanks,

greg k-h
