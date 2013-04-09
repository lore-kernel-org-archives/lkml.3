Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936013Ab3DIL2f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 07:28:35 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:60580 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932926Ab3DIL2d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 07:28:33 -0400
Date: Tue, 9 Apr 2013 07:28:24 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Adrian Chadd <adrian@freebsd.org>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
        Eugene Krasnikov <k.eugene.e@gmail.com>, Kalle Valo <kvalo@adurom.com>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        ath9k_htc_fw <ath9k_htc_fw@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Version number policy!
Message-ID: <20130409112824.GA12050@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Adrian Chadd <adrian@freebsd.org>,
	Christian Lamparter <chunkeey@googlemail.com>,
	Eugene Krasnikov <k.eugene.e@gmail.com>,
	Kalle Valo <kvalo@adurom.com>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	linux-bluetooth <linux-bluetooth@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	ath9k_htc_fw <ath9k_htc_fw@lists.infradead.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <CAJ-Vmo=LVSzdEo6DhfOVT_0JHCTMmdPU1zGfMuBmhmr8QuDmJQ@mail.gmail.com>
 <CAJ-VmomS_=1=QLZrfdD4vhu9Qy0w2JNQxEFrkt_OKjWetrWY4w@mail.gmail.com>
 <CAFSJ42b7DD9UVtzT7YWhaEchzwpde0yW=pS3nJVeMCHoVQGBqQ@mail.gmail.com>
 <201304090003.47056.chunkeey@googlemail.com>
 <CAJ-VmomksDSNvTpKQpNRRQx+QboSVHpby7V4qq4rngqVkTvf+A@mail.gmail.com>
 <20130409003720.GA5145@thunk.org>
 <CAJ-VmokQ=1FLnn-0Ew1JTY_WhYuSYmZq2=DuNTV0TR3kF4wo7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ-VmokQ=1FLnn-0Ew1JTY_WhYuSYmZq2=DuNTV0TR3kF4wo7g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 08, 2013 at 06:51:10PM -0700, Adrian Chadd wrote:
> 
> But then you end up with people making filesystems which aren't
> necessarily backwards compatible (and aren't aware of this), then try
> to share with other extX implementations; or boot an older Linux
> kernel (eg plugging an ext3 device on a newer box to an older box.)
> Now, ext3 is a bit more mature nowdays so people aren't _always_
> hitting this corner case.

You have a long memory --- going back to about seven years ago, to
2006....

> I'm not knocking extX here; I'm just pointing out that exposing things
> as a set of capability flags doesn't magically fix interoperability.
> It just stops you from scribbling crap where it shouldn't be.

Sure, the only question is how long do you support ancient file
systems out there.  I consider that primarily a distribution question,
not an upstream development question.  People who pay $$$ for ancient
crud, expect that the people to whom they have paid $$$ will take care
of that problem for them.  From an upstream development perspective,
some people might argue that two years is plenty of time to wait for
the vast majority of the people running community distributions to
have upgraded (and if they want more than that, they can pay $$$ to
the aforementioned enterprise distro's, or take care of that situation
on their own).

						- Ted
