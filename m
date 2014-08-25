Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756509AbaHYTO1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 15:14:27 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60481 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189AbaHYTOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 15:14:25 -0400
Message-ID: <1408994058.8997.33.camel@fourier>
Subject: Re: [3.8.y.z extended stable] Linux 3.8.13.28 stable review
From: Kamal Mostafa <kamal@canonical.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com, "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, 25 Aug 2014 12:14:18 -0700
In-Reply-To: <20140825170033.GA18021@kroah.com>
References: <1408985699-31838-1-git-send-email-kamal@canonical.com>
	 <20140825170033.GA18021@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-08-25 at 10:00 -0700, Greg KH wrote:
> On Mon, Aug 25, 2014 at 09:54:46AM -0700, Kamal Mostafa wrote:
> > This is the start of the review cycle for the Linux 3.8.13.28 stable kernel.
> > 
> >  ** NOTE: This will be the last Linux 3.8.y.z extended stable version
> >  ** to be released and supported by me and the Ubuntu Kernel team.
> 
> I know this is the last release, but I have gotten some complaints by
> people who are confused by the numbering scheme you are using for the
> Canonical stable kernel releases.  Can you please use the EXTRAVERSION
> field with a "-something" tag in it to differenciate from the "normal"
> kernel.org stable releases?

We'll consider that idea for future extended stable versions maintained
by our team.

Thanks,

 -Kamal


> A simple "-ubuntu" or "-canonical" or "-fuzzy_bunnies" marking would be
> fine, or whatever you want to pick.
> 
> Everyone used to do this a long time ago when we had lots of different
> kernel releases / trees floating around in the pre-git days, which made
> things much easier to figure out where the trees came from.
> 
> thanks,
> 
> greg k-h
> 


