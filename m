Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993AbaBRTHJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 14:07:09 -0500
Received: from imap.thunk.org ([74.207.234.97]:59665 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751749AbaBRTHF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 14:07:05 -0500
Date: Tue, 18 Feb 2014 14:06:55 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Jeff Chua <jeff.chua.linux@gmail.com>, Takashi Iwai <tiwai@suse.de>,
        Peter Hurley <peter@hurleysoftware.com>,
        lkml <linux-kernel@vger.kernel.org>, Dave Airlie <airlied@redhat.com>
Subject: Re: Lenovo X240 (haswell) suspend-to-ram hangs on 3-14.0-rc2
Message-ID: <20140218190655.GA7649@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Jeff Chua <jeff.chua.linux@gmail.com>, Takashi Iwai <tiwai@suse.de>,
	Peter Hurley <peter@hurleysoftware.com>,
	lkml <linux-kernel@vger.kernel.org>,
	Dave Airlie <airlied@redhat.com>
References: <CAAJw_ZvX2AfS8COiNdN9gi_1xJ4L_vL=ROCzcLL3u0h51kuX3Q@mail.gmail.com>
 <52FCFD92.7040109@hurleysoftware.com>
 <s5hiosi3osp.wl%tiwai@suse.de>
 <CAAJw_ZsoO=kd6cVM3HYrkim5K0RKrnDXYGgodNNQmHVYs19a8A@mail.gmail.com>
 <s5hha8123vu.wl%tiwai@suse.de>
 <CAAJw_ZtviRCtaC4-3_ubkYuEt+LYstwbi6qus-5GOoOLYhfecw@mail.gmail.com>
 <s5hk3cxzce0.wl%tiwai@suse.de>
 <CAAJw_ZtK+jTOhCPZKhCu_f2nHwUahE8jcR8G4+FbocEc66Ei4g@mail.gmail.com>
 <20140217195432.GE16660@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140217195432.GE16660@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 17, 2014 at 02:54:32PM -0500, Theodore Ts'o wrote:
> On Tue, Feb 18, 2014 at 01:54:40AM +0800, Jeff Chua wrote:
> > Any suggestion on how to debug this? bisect? Ted, does your T540p work
> > with CONFIG_SND_HDA_INTEL=y instead of "m" ?
> 
> I can give this a try on my next kernel rebuild.

I can confirm that suspend-to-ram hangs on my T540p if I build with
CONFIG_SND_HDA_INTEL=y.  I ran the test using v3.14-rc3.

						- Ted
