Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750972AbaHTEDM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 00:03:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58822 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703AbaHTEDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 00:03:11 -0400
Date: Tue, 19 Aug 2014 23:02:29 -0500
From: Greg KH <gregkh@linuxfoundation.org>
To: Valentina Manea <valentina.manea.m@gmail.com>
Cc: =?utf-8?B?VMO8bGluIMSwemVy?= <tulinizer@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>, mail@beyermatthias.de,
        hdegoede@redhat.com, Federico Manzan <f.manzan@gmail.com>,
        Kurt Garloff <kurt@garloff.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Linux Kernel Community @ ROSEdu" <firefly@lists.rosedu.org>,
        Andy Grover <andy.grover@gmail.com>, max@vozeler.com
Subject: Re: [PATCH 2/3] usbip: move usbip kernel code out of staging
Message-ID: <20140820040229.GA5659@kroah.com>
References: <1407388229-31807-1-git-send-email-valentina.manea.m@gmail.com>
 <1407388229-31807-4-git-send-email-valentina.manea.m@gmail.com>
 <20140819183825.GA2477@kroah.com>
 <CABdoFFfBFVd-JR+T-5JwpKejmW2skqiMotguhm3458wSZtq8rQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABdoFFfBFVd-JR+T-5JwpKejmW2skqiMotguhm3458wSZtq8rQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2014 at 08:21:47PM -0700, Valentina Manea wrote:
> On Tue, Aug 19, 2014 at 11:38 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > This patch moves the code, but now it's "gone" from the build system as
> > it is not hooked up and can not be built at all.
> >
> > So while I really wanted to apply this series right now, I can't, as
> > this is a regression (working driver -> no driver).
> 
> You mean it should be in Kbuild and Makefile from drivers/, right?

Yes, in drivers/usb/

thanks,

greg k-h
