Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758937AbbA0SAf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 13:00:35 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59169 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758651AbbA0SAd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 13:00:33 -0500
Message-ID: <1422381619.14108.21.camel@linux-0dmf.site>
Subject: Re: USB autosuspend causing trouble with bluetooth
From: Oliver Neukum <oneukum@suse.de>
To: Kirill Elagin <kirelagin@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Date: Tue, 27 Jan 2015 19:00:19 +0100
In-Reply-To: <CABVT_gcm0-3in9uOhpwM7VJrEdaE6982X01TGD29if8OQEW4Uw@mail.gmail.com>
References: <CABVT_gf-rx0ymvtCrCotkO5=qoDifG1yAMg8U_aTgXEN=x6gvg@mail.gmail.com>
	 <1421751814.29486.13.camel@linux-0dmf.site>
	 <CABVT_gcqjp1V6vnOOSewYYeR2PmngAQhuR+fud=bDU6FJ8Bnqw@mail.gmail.com>
	 <1421762788.29486.28.camel@linux-0dmf.site>
	 <CABVT_gdCvbK8mUQMjDmiAmc_6kbBUMf4XFeAZ=zzjOYS+7oCGg@mail.gmail.com>
	 <1421775689.1112.4.camel@linux-0dmf.site>
	 <CABVT_geh3RjaG+zX6xUWL9RQtwoAeyuC33xf2vT2o0HPPkokcg@mail.gmail.com>
	 <1421790436.1112.14.camel@linux-0dmf.site>
	 <CABVT_geRjB12v8XnRvNbf_2h6-hQJwgxuFkqxBhwQv2nrZ-w9A@mail.gmail.com>
	 <CABVT_gcm0-3in9uOhpwM7VJrEdaE6982X01TGD29if8OQEW4Uw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2015-01-26 at 21:00 +0400, Kirill Elagin wrote:
> Things just got way worse with this hotplug thing.

Is that a new test or did you update?

> When the host power/control is set to `auto`, as soon as I insert  the
> Unifying receiver one of kworkers starts eating 100% of one of the

But it does not enumerate the dongle, does it?

> cores, according to `htop`. As soon as I `echo on` to power/control of
> the relevant USB hub the kworker stops doing this. This also happens
> with that other USB1.1 BT-dongle, so I assume any USB1.1 device would
> do. Also just unplugging the device is not enough, the kworker keeps
> eating CPU until I `echo on` to power/control.
> 
> Should I start a separate thread?
> Right now I'm on 3.18.2-gentoo.

Can you tell at which kernel version this started?

	Regards
		Oliver


