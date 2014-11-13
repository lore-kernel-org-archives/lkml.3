Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932687AbaKMLPE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 06:15:04 -0500
Received: from mx02.posteo.de ([89.146.194.165]:45886 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932364AbaKMLPC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 06:15:02 -0500
In-Reply-To: <CAJfpegud-NAbDroWAr+mROUGLPviCaQKa8P5n6bZmA+0GF_qMA@mail.gmail.com>
References: <20141112112643.GA30821@ulmo.nvidia.com> <1415809894-24084-1-git-send-email-martink@posteo.de> <CAJfpegt2Xz0tGUygpN4eyb3g8EsFNWomsUUOmGBMj03ocOPVng@mail.gmail.com> <B51BC89F-99DB-4F9A-A1E3-14D9627E2496@posteo.de> <CAJfpegud-NAbDroWAr+mROUGLPviCaQKa8P5n6bZmA+0GF_qMA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH] fuse: don't check for file->private_data on open().
From: Martin Kepplinger <martink@posteo.de>
Date: Thu, 13 Nov 2014 12:13:32 +0100
To: Miklos Szeredi <miklos@szeredi.hu>
CC: fuse-devel <fuse-devel@lists.sourceforge.net>, thierry.reding@gmail.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        giedriuswork@gmail.com,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-ID: <0198135B-B7F1-4E40-A9E2-C9D56C421B6F@posteo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 13. November 2014 11:53:29 MEZ, schrieb Miklos Szeredi <miklos@szeredi.hu>:
>On Thu, Nov 13, 2014 at 11:05 AM, Martin Kepplinger <martink@posteo.de>
>wrote:
>
>> In this week's -next this should have changed. My SSD broke down so i
>have to delay further work for a few days, i'm sorry.
>
>Please be more careful with such patches.  Have you audited all of the
>(ca. 200) misc drivers?  If not, this might be a good time to do so.
>If it turns out to be too much, then consider not doing the change.
>The gain might not be worth the cost.
>
>NACK in this form.
>
>Thanks,
>Miklos

Definitely should have been more careful as I checked fs too late now. I totally unnecessarily broke -next.

But If fuse-devel is ok with a fix like the one i sent (still has to get tested too) i believe we're covered. I still call for independent review though.
-- 
Martin Kepplinger
http://martinkepplinger.com
sent from mobile
