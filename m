Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528Ab3I3OtH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 10:49:07 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:52546 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941Ab3I3OtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 10:49:05 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: VDR User <user.vdr@gmail.com>
Cc: Adam Lee <adam.lee@canonical.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg@redhat.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        "open list:USB VIDEO CLASS" <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Revert "V4L/DVB: uvc: Enable USB autosuspend by default on uvcvideo"
Date: Mon, 30 Sep 2013 16:49:10 +0200
Message-ID: <2929853.aH7hYkoiDo@avalon>
User-Agent: KMail/4.10.5 (Linux/3.8.13-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <CAA7C2qi_1yYeSYbRBFhaLLwEmFf0k4G52jwvXVk0yLpNFFPCJA@mail.gmail.com>
References: <1366790239-838-1-git-send-email-adam.lee@canonical.com> <1657156.ZjLeh8FSxj@avalon> <CAA7C2qi_1yYeSYbRBFhaLLwEmFf0k4G52jwvXVk0yLpNFFPCJA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tuesday 24 September 2013 08:55:19 VDR User wrote:
> On Tue, Sep 24, 2013 at 4:34 AM, Laurent Pinchart wrote:
> > I've discussed this issue during LPC last week, and I still believe we
> > should enable auto-suspend. The feature really saves power, without it my
> > C910 Logitech webcam gets hot even when unused.
> > 
> > If we disable auto-suspend by default and enable it from userspace only a
> > handful of devices will get auto-suspended. Unless we can get distros to
> > automatically test auto-suspend on unknown webcam models and report the
> > results to update a central data base (which would grow much bigger than a
> > quirks list in the driver in my opinion), disabling auto-suspend would be
> > a serious regression.
> 
> Setting defaults which knowingly cause problems is a horrible idea. Just
> because it works for you and your setup is no justification to force it upon
> everyone. This is certainly a feature that, if wanted, can be enabled by the
> user.

It's not just my setup, auto-suspend works for the vast majority of webcams. 
It has been enabled three years ago, with a report that Fedora had enabled it 
by carrying a kernel patch for a while, without any user complaint.

> I don't see any reasonable argument against letting the user enable it if
> he/she wants it.

USB autosuspend is an important power saving feature. I would be fine with 
enabling it in userspace if we could find a reasonable, cross-distro way to 
create, maintain and distribute the list of devices that support USB 
autosuspend properly.

-- 
Regards,

Laurent Pinchart

