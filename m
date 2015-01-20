Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177AbbATOGl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 09:06:41 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52191 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752117AbbATOGk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 09:06:40 -0500
Message-ID: <1421762788.29486.28.camel@linux-0dmf.site>
Subject: Re: USB autosuspend causing trouble with bluetooth
From: Oliver Neukum <oneukum@suse.de>
To: Kirill Elagin <kirelagin@gmail.com>
Cc: linux-kernel@vger.kernel.org
Date: Tue, 20 Jan 2015 15:06:28 +0100
In-Reply-To: <CABVT_gcqjp1V6vnOOSewYYeR2PmngAQhuR+fud=bDU6FJ8Bnqw@mail.gmail.com>
References: <CABVT_gf-rx0ymvtCrCotkO5=qoDifG1yAMg8U_aTgXEN=x6gvg@mail.gmail.com>
	 <1421751814.29486.13.camel@linux-0dmf.site>
	 <CABVT_gcqjp1V6vnOOSewYYeR2PmngAQhuR+fud=bDU6FJ8Bnqw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2015-01-20 at 16:18 +0400, Kirill Elagin wrote:
> I use a Logitech wireless keyboard (with a Unifying receiver) and it
> keeps working fine even with `auto`.
> 
> That is, everything is OK if the receiver is plugged before
> `power/control` is switched to `auto`.

Wait. There is no power/control file for the receiver before
you plug it in. We are having a very big misunderstanding here.

> But if I first set it to `auto`, then plug the receiver in, it is not
> detected (nothing in dmesg). Kernel
> detects it as soon as I `echo on` to the relevant `power/control`.

Are you on power/control for the device or the port?
If you are using the port's control file you might be switching
on Port Power Off. Then of course the port will not process
hotplugs. Please clarify!
> 
> This laptop is too old to have USB3.0, both the receiver and BT are
> attached to USB1.1 ports.
> BTW I also noticed a strange thing: USB devices appear on different
> buses when attached,
> depending on their speed (e.g. the keyboard receiver is on bus 6 which
> is USB1.1, while a
> USB stick appears on bus 2 which is USB2.0 when I plug it into that
> same physical port).
> I’m not sure whether this is strange or normal, as I never really
> payed attention.

That is perfectly normal.

	Regards
		Oliver

PS: Please dont top-post


