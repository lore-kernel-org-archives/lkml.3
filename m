Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140AbaBMVWH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 16:22:07 -0500
Received: from imap.thunk.org ([74.207.234.97]:57682 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751199AbaBMVWE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 16:22:04 -0500
Date: Thu, 13 Feb 2014 16:21:56 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Takashi Iwai <tiwai@suse.de>
Cc: Peter Hurley <peter@hurleysoftware.com>,
        Jeff Chua <jeff.chua.linux@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>, Dave Airlie <airlied@redhat.com>
Subject: Re: Lenovo X240 (haswell) suspend-to-ram hangs on 3-14.0-rc2
Message-ID: <20140213212156.GB11480@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Takashi Iwai <tiwai@suse.de>,
	Peter Hurley <peter@hurleysoftware.com>,
	Jeff Chua <jeff.chua.linux@gmail.com>,
	lkml <linux-kernel@vger.kernel.org>,
	Dave Airlie <airlied@redhat.com>
References: <CAAJw_ZvX2AfS8COiNdN9gi_1xJ4L_vL=ROCzcLL3u0h51kuX3Q@mail.gmail.com>
 <52FCFD92.7040109@hurleysoftware.com>
 <s5hiosi3osp.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hiosi3osp.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For what it's worth, I have a the X240's bigger brother --- a T540p
(with intel graphics and the 3k panel) running 3.14-rc2, and
suspend-to-ram is working without any problems on my laptop.

Cheers,

						- Ted
