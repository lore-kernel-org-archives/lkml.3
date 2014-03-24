Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441AbaCXP2Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 11:28:16 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:30567 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754AbaCXP2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 11:28:14 -0400
X-AuditID: cbfee61b-b7f456d000006dfd-e3-53304f0cee28
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: "David F." <df7729@gmail.com>, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org
Subject: Re: patch fix for intel sdd s3500 series on Sil3512 controller
Date: Mon, 24 Mar 2014 16:27:54 +0100
Message-id: <2140283.ClKsmfFTvU@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <20140324141558.31c169cf@alan.etchedpixels.co.uk>
References: <CAGRSmLtifL=hFBP1AUHB_va6ZvNfqXo8Bu=6XciH--jOEYVJjQ@mail.gmail.com>
 <20140324141558.31c169cf@alan.etchedpixels.co.uk>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=US-ASCII
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrALMWRmVeSWpSXmKPExsVy+t9jQV0ef4NggzNHtC3m35KymDTlL5vF
	sR2PmCwu75rD5sDisXPWXXaP1pObWD0+b5ILYI7isklJzcksSy3St0vgyli4ewpLwWrWihdT
	jrA3ME5g6WLk4JAQMJHY8UWgi5ETyBSTuHBvPVsXIxeHkMB0RolJDZNZIZwWJon2ty+YQarY
	BKwkJravYgSxRYCam1+9BrOZBWIkbs9sB6sRFnCXOHXsEVicRUBV4nNzOzvIMl4BTYmVb1RA
	wqICnhI7tq9kA7E5BewkHpz/yA5iCwm0MUpcPSQKYvMKCEr8mHyPBWK8vMS+/VNZIWwtic3b
	mlgnMArMQlI2C0nZLCRlCxiZVzGKphYkFxQnpeca6RUn5haX5qXrJefnbmIEh+sz6R2Mqxos
	DjEKcDAq8fBuMDUIFmJNLCuuzD3EKMHBrCTCe0ocKMSbklhZlVqUH19UmpNafIhRmoNFSZz3
	YKt1oJBAemJJanZqakFqEUyWiYNTqoExV0Pngtx0Me6dH7fwnXiU5VI6ee4X0+O9OVXuJ1cy
	ezxNu37r08npGpIT6maWNZyeGCrYVy3LzcD+PGhv9oTodSpcKSrnb26L4DtpNSvx8uXq/FNc
	Dpu5UuPOK//b7bdi9tG8C4s+xK84aOQZ+Lv91zvRhCSVtfrXG8M+qUbcOOT/5otQk/ExJZbi
	jERDLeai4kQAn0EiLFMCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


+ linux-ide mailing list on Cc:

On Monday, March 24, 2014 02:15:58 PM One Thousand Gnomes wrote:
> On Sat, 22 Mar 2014 16:32:54 -0700
> "David F." <df7729@gmail.com> wrote:
> 
> > Hi,
> > 
> > It appears if nIEN is set all polling type IO fails.   After an
> > attempt, future non-polled communications also fails.  This patch
> > allows it to work.  Not sure if any spin lock protection would be
> > needed or the system already handles the device existence for the
> > generated irq with polling enabled.  handler already ignored irq if
> > queued command was polling type.
> 
> Does it behave plugged into a different controller without the hacks ?
> 
> Alan

