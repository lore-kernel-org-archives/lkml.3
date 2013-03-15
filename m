Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980Ab3COQiK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 12:38:10 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:41455 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232Ab3COQiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 12:38:07 -0400
Date: Fri, 15 Mar 2013 09:38:03 -0700
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "thierry.reding@avionic-design.de" <thierry.reding@avionic-design.de>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>
Subject: Re: [PATCH 3/3] serial: tegra: Convert to devm_ioremap_resource()
Message-ID: <20130315163803.GA29113@kroah.com>
References: <1359627939-2685-1-git-send-email-sachin.kamat@linaro.org>
 <1359627939-2685-3-git-send-email-sachin.kamat@linaro.org>
 <510AA318.5060208@wwwdotorg.org>
 <CAK9yfHzSq8SpKXQYtFd1Ds+N-AoH+H+BdWrPsPT=OwSPdst1WA@mail.gmail.com>
 <510B436A.20808@wwwdotorg.org>
 <CAK9yfHzJvOC_wvsxvapi7rATq97QX-6exOyqjNTSguhh3RLVvQ@mail.gmail.com>
 <510BF8EC.7090801@wwwdotorg.org>
 <CAK9yfHx1jLPpdCHAb-pC-C7wt81gQLgTnpuvK+0aNKkhuXHcDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK9yfHx1jLPpdCHAb-pC-C7wt81gQLgTnpuvK+0aNKkhuXHcDQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 02, 2013 at 10:22:16AM +0530, Sachin Kamat wrote:
> 
> 
> On Friday, 1 February 2013, Stephen Warren <swarren@wwwdotorg.org> wrote:
> > On 02/01/2013 02:49 AM, Sachin Kamat wrote:
> >> On 1 February 2013 09:54, Stephen Warren <swarren@wwwdotorg.org> wrote:
> >>>>
> >>>> The entire series is merged in Greg's driver-core tree [1] and I
> >>>> presume all other associated patches would also be picked up by him.
> >>>> Isn't it Greg?
> >>>>
> >>>> [1] git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git
> >>>
> >>> The Tegra serial driver went through Greg's TTY tree. I assume that goes
> >>> direct to Linus not through driver-core.git first.
> >>
> >> Right. But AFAIK for this specific change he has carried the patches
> >> in the device-core tree irrespective of the subsystem.
> >
> > Yes, but the Tegra serial driver is new for 3.9, and hence does not yet
> > exist in driver-core.git.
> >
> 
> Oh ok. Then probably we can have this patch only after 3.9-rc1 is out.

Yes, Stephen can take this patch now.

