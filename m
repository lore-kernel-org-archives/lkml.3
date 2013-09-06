Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832Ab3IFWUT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 18:20:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37027 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892Ab3IFWUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 18:20:16 -0400
Date: Fri, 6 Sep 2013 15:20:15 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Olof Johansson <olof@lixom.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, stable@vger.kernel.org
Subject: Re: [ 00/36] 3.10.11-stable review
Message-ID: <20130906222015.GA31733@kroah.com>
References: <20130905202702.289738686@linuxfoundation.org>
 <CAOesGMgHwkU9Tih98ucDCqB815Abk=+e2TQNYkyMn-h0PY--pg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOesGMgHwkU9Tih98ucDCqB815Abk=+e2TQNYkyMn-h0PY--pg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 06, 2013 at 03:08:06PM -0700, Olof Johansson wrote:
> On Thu, Sep 5, 2013 at 1:27 PM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > This is the start of the stable review cycle for the 3.10.11 release.
> > There are 36 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sat Sep  7 20:26:25 UTC 2013.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.11-rc1.gz
> > and the diffstat can be found below.
> 
> FYI; I've started tracking the 3.10+ queues on my builder/booter for
> arm-soc platforms.
> 
> I don't plan on posting the logs but will keep an eye on them and
> report (new) failures that aren't seen on the baseline. I poll for new
> patches a few times an hour.

That would be great to know, thanks for doing this.

greg k-h
