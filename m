Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547Ab3LCMdL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 07:33:11 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:43033 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775Ab3LCMdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 07:33:07 -0500
Date: Tue, 3 Dec 2013 12:32:53 +0000
From: Kim Phillips <kim.phillips@linaro.org>
To: gregkh@linuxfoundation.org
Cc: B08248@freescale.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: driver core patches
Message-Id: <20131203123253.9fd9b92ff0170b214e69f18b@linaro.org>
In-Reply-To: <20131106021247.GB6687@kroah.com>
References: <9F6FE96B71CF29479FF1CDC8046E15036F480C@039-SN1MPN1-002.039d.mgd.msft.net>
	<20131106021247.GB6687@kroah.com>
X-Mailer: Sylpheed 3.4.0beta5 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Nov 2013 18:12:47 -0800
"gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org> wrote:

> On Tue, Nov 05, 2013 at 10:53:36PM +0000, Stuart Yoder wrote:
> > Hi Greg,
> > 
> > Any feedback on the driver core patches in Kim Phillips patch series
> > from mid-October?
> > 
> > The 3rd patch of the series has some open issues related to vfio-pci,
> > but the first two are driver core related and am wondering if they
> > are acceptable.
> 
> As I saw there was lots of discussion, and some rework needed, I haven't
> paid any attention to them, expecting to see another set show up.

the first two patches didn't receive any feedback, whilst the 3rd broke
vfio-pci userspace i/f compatibility, so I'm going to assume that 1 and
2 are acceptable and work to enable rebinding platform devices, and
that vfio-pci can transition over later.

> Also, it's way past the merge window, and I can't do anything with any
> new patches until after 3.13-rc1 is out, combined with a
> travel-schedule-from-hell, and I really am not going to want to review
> these types of patches for a number of weeks.
> 
> So take the time, fix them up, and send them after 3.13-rc2 is out or so
> and I should have a chance to look at them then.  Hopefully I'll hate
> them less by then, but I'm not guaranteeing anything...

ok, 3.13-rc2 is out, so I'm going to repost 1 & 2 now.

fwiw, I'm omitting the fourth patch to reduce confusion because it
depends on Antonios Motakis' vfio-platform WIP patchseries.

Kim
