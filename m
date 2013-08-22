Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752338Ab3HVI5Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 04:57:25 -0400
Received: from mail.skyhub.de ([78.46.96.112]:47463 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751892Ab3HVI5X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 04:57:23 -0400
Date: Thu, 22 Aug 2013 10:57:21 +0200
From: Borislav Petkov <bp@alien8.de>
To: Tony Luck <tony.luck@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>, lwn@lwn.net,
        Guenter Roeck <linux@roeck-us.net>, Hugh Dickins <hughd@google.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Proposed stable release changes
Message-ID: <20130822085721.GA16792@nazgul.tnic>
References: <20130820224032.GA20491@kroah.com>
 <521504D7.7090204@wwwdotorg.org>
 <CA+55aFxMkQoJAJd2=XyJu0NX2dG3mX=obx=YL6YXatLg4S=-Vw@mail.gmail.com>
 <20130821200034.GA10671@nazgul.tnic>
 <CA+8MBbKxcQCq8XdYakG5Dg8F_G8NunQjca-TyZbn4q0v3okaqw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+8MBbKxcQCq8XdYakG5Dg8F_G8NunQjca-TyZbn4q0v3okaqw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21, 2013 at 01:54:01PM -0700, Tony Luck wrote:
> On Wed, Aug 21, 2013 at 1:00 PM, Borislav Petkov <bp@alien8.de> wrote:
> > We don't want to run daily snapshots of your tree though, right? Only
> > -rcs because the daily states are kinda arbitrary and they can be broken
> > in various ways. Or are we at a point in time where we can amend that
> > rule?
> 
> If *nobody* runs daily snapshots - then problems just sit latent all week until
> the -rc is released and people start testing. Doesn't sound optimal.
> 
> Running daily git snapshots can be "exciting" during the merge window. But
> I rarely see problems running a random build after -rc1.  If you are still
> running that ancient 3.11-rc6 released on Sunday - then you are missing out
> on 28 commits worth of goodness since then :-)

Damn, I'm such a l0z3r!
