Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932662AbaKMKxd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 05:53:33 -0500
Received: from mail-qc0-f173.google.com ([209.85.216.173]:33585 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932364AbaKMKxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 05:53:30 -0500
MIME-Version: 1.0
X-Originating-IP: [46.139.80.5]
In-Reply-To: <B51BC89F-99DB-4F9A-A1E3-14D9627E2496@posteo.de>
References: <20141112112643.GA30821@ulmo.nvidia.com>
	<1415809894-24084-1-git-send-email-martink@posteo.de>
	<CAJfpegt2Xz0tGUygpN4eyb3g8EsFNWomsUUOmGBMj03ocOPVng@mail.gmail.com>
	<B51BC89F-99DB-4F9A-A1E3-14D9627E2496@posteo.de>
Date: Thu, 13 Nov 2014 11:53:29 +0100
Message-ID: <CAJfpegud-NAbDroWAr+mROUGLPviCaQKa8P5n6bZmA+0GF_qMA@mail.gmail.com>
Subject: Re: [PATCH] fuse: don't check for file->private_data on open().
From: Miklos Szeredi <miklos@szeredi.hu>
To: Martin Kepplinger <martink@posteo.de>
Cc: fuse-devel <fuse-devel@lists.sourceforge.net>, thierry.reding@gmail.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        giedriuswork@gmail.com,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2014 at 11:05 AM, Martin Kepplinger <martink@posteo.de> wrote:

> In this week's -next this should have changed. My SSD broke down so i have to delay further work for a few days, i'm sorry.

Please be more careful with such patches.  Have you audited all of the
(ca. 200) misc drivers?  If not, this might be a good time to do so.
If it turns out to be too much, then consider not doing the change.
The gain might not be worth the cost.

NACK in this form.

Thanks,
Miklos
