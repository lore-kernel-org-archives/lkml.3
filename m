Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936593Ab3DIAhl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 20:37:41 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:60430 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936310Ab3DIAhj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 20:37:39 -0400
Date: Mon, 8 Apr 2013 20:37:20 -0400
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
Message-ID: <20130409003720.GA5145@thunk.org>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ-VmomksDSNvTpKQpNRRQx+QboSVHpby7V4qq4rngqVkTvf+A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 08, 2013 at 04:12:07PM -0700, Adrian Chadd wrote:
> I'm a FreeBSD user. I know what it's like to have an alternate, out of
> linux implementation of ext2/3 that doesn't implement all of the
> features.
> 
> I also know what kinds of crap happens when you try mounting a more
> recent extX filesystem on an earlier kernel. Ie, it doesn't
> necessarily end well. :-)

There shouldn't be any crap; just a an error message indicating that
"the file system has features which this implementation doesn't
understand".  At least, if the implementation was competently
coded.... (ext2/3/4 has feature bitmasks that make it very clear what
features are required so that an implementation can mount the file
system read/write or read/only).

							- Ted
