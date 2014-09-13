Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752093AbaIMPig (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 11:38:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34486 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976AbaIMPif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 11:38:35 -0400
Date: Sat, 13 Sep 2014 08:37:47 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sedat Dilek <sedat.dilek@gmail.com>
Cc: stable@vger.kernel.org, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-3.16.y: acpi-battery fixes
Message-ID: <20140913153747.GA11973@kroah.com>
References: <CA+icZUW8vHj9_L-4WD0FR6mUTWW621T5O-Cd=fSJ_UoPX0BQUg@mail.gmail.com>
 <20140913152438.GA3072@kroah.com>
 <CA+icZUX0vNpi7F-P8RAqzqPWhS2pD+XdppHXcEeKy=W94n+jxA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+icZUX0vNpi7F-P8RAqzqPWhS2pD+XdppHXcEeKy=W94n+jxA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 13, 2014 at 05:32:50PM +0200, Sedat Dilek wrote:
> 
> With jumping to Linux v3.16.y I have 1st seen that my battery reports
> 85% whereas the LED shows me it's full (green vs. charging orange).
> So, I hoped the fix from Bjorn fixes the issue for me but did not help here.
> Those acpi-battery fixes are labeled for 3.16+, don't you get them
> automatically and consider for inclusion?

I do get them, so if they are marked for stable, they should be in a
future stable kernel release, no need to do anything on your end.

But note, I'm way behind in stable patches as there are about 300+
pending ones.

> No, I did not try the pending ACPI patches in the stable-queue tree.
> Is there a stable-review v3.16.3-rc1 around?

That should happen next week, until then, there is the stable-queue on
git.kernel.org if you want to see what is queued up.

thanks,

greg k-h
