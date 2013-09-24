Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282Ab3IXP6n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 11:58:43 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:49642 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753983Ab3IXP6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 11:58:41 -0400
MIME-Version: 1.0
In-Reply-To: <1657156.ZjLeh8FSxj@avalon>
References: <1366790239-838-1-git-send-email-adam.lee@canonical.com>
	<20130425063306.GA20928@adam-laptop>
	<20130613095647.GC21583@adam-laptop>
	<1657156.ZjLeh8FSxj@avalon>
Date: Tue, 24 Sep 2013 08:58:40 -0700
Message-ID: <CAA7C2qhpUnqCC8ikQ39Sn26jD3iphjOhL-0t09vBdKskvuz9MA@mail.gmail.com>
Subject: Re: [PATCH] Revert "V4L/DVB: uvc: Enable USB autosuspend by default
 on uvcvideo"
From: VDR User <user.vdr@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Adam Lee <adam.lee@canonical.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg@redhat.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        "open list:USB VIDEO CLASS" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 24, 2013 at 4:34 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> I've discussed this issue during LPC last week, and I still believe we should
> enable auto-suspend. The feature really saves power, without it my C910
> Logitech webcam gets hot even when unused.
>
> If we disable auto-suspend by default and enable it from userspace only a
> handful of devices will get auto-suspended. Unless we can get distros to
> automatically test auto-suspend on unknown webcam models and report the
> results to update a central data base (which would grow much bigger than a
> quirks list in the driver in my opinion), disabling auto-suspend would be a
> serious regression.

Setting defaults which knowingly cause problems is a horrible idea.
Just because it works for you and your setup is no justification to
force it upon everyone. This is certainly a feature that, if wanted,
can be enabled by the user. I don't see any reasonable argument
against letting the user enable it if he/she wants it.

Ps. Sorry for the double-post if anyone already received this. The
first posting wasn't using plain text and was therefore rejected so
this corrects that.
