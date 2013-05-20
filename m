Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755066Ab3ETBou (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 May 2013 21:44:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40214 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753755Ab3ETBot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 May 2013 21:44:49 -0400
Date: Sun, 19 May 2013 18:45:06 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Chen Gang <gang.chen@asianux.com>
Cc: Ming Lei <tom.leiming@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Consult] Why need we call device_remove_file() firstly before
 call device_unregister() ?
Message-ID: <20130520014506.GA2201@kroah.com>
References: <5195C39F.9010101@asianux.com>
 <CACVXFVNiWwiXtubJSbE3z6-AyxcOBgyvhn+2diHyi5Nyj4XYeg@mail.gmail.com>
 <5199765F.5000905@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5199765F.5000905@asianux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 20, 2013 at 09:03:27AM +0800, Chen Gang wrote:
> On 05/18/2013 07:06 PM, Ming Lei wrote:
> > Hi,
> > 
> > On Fri, May 17, 2013 at 1:43 PM, Chen Gang <gang.chen@asianux.com> wrote:
> >> Hello All:
> >>
> >> I searched 'arch/*' and 'drivers/*' sub-directory, all of them are 'obey
> >> this rule', even in device_unregister() itself, it also firstly calls
> >> device_remove_file(), then call kobject_del().
> >>
> >> But after read the related code (fs/sysfs/*, drivers/base/core.c), it
> >> seems kobject_del() -> sysfs_remove_dir() which will release all related
> >> things (can instead of device_remove_file()).
> >>
> >> So in fact, we need not call device_remove_file() before call
> >> device_unregister(), is it correct ?
> > 
> > Looks it is correct but it is a bit implicit.
> > 
> 
> If really no other members reply within a week, we should treat your
> opinion (or suggestion) as the final result conclusion within
> linux-kernel@vger.kernel.org.  :-)

I have no idea what you mean by this.

