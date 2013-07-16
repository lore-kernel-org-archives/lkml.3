Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933711Ab3GPRhA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 13:37:00 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:59777 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933569Ab3GPRg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 13:36:57 -0400
MIME-Version: 1.0
In-Reply-To: <51E58190.4050808@nod.at>
References: <1373993525-25629-1-git-send-email-artagnon@gmail.com>
 <51E57BC1.4090904@nod.at> <CALkWK0nrDsZiHe2==DQZuHV7id=6gc4UHUj1xXu9jN5cr3SUcQ@mail.gmail.com>
 <51E57DF3.90304@nod.at> <CALkWK0m0LkjFzOUXRQmdDuS+L7mKA87qCMq=MYX6UrnHXi+XRg@mail.gmail.com>
 <CALkWK0=qw_K=6+6btjzcMS9VmDdVbF++rN=3-=Kgzu-3xSErrQ@mail.gmail.com> <51E58190.4050808@nod.at>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Tue, 16 Jul 2013 23:06:16 +0530
Message-ID: <CALkWK0mDtxNPRnU480k8wiNt+i7gpVHLz8Za4+368_L8bU9Teg@mail.gmail.com>
Subject: Re: [PATCH] um/configs: don't use devtmpfs in defconfig
To: Richard Weinberger <richard@nod.at>
Cc: LKML <linux-kernel@vger.kernel.org>, Jeff Dike <jdike@addtoit.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Weinberger wrote:
> BTW: I'll not apply any patch to the kernel if the issue can easily
> fixed in user space, that's the major reason for my NAK.

I was just asking for good defaults; I want um Linux to work
out-of-the-box.  There's really no point in creating bogus devices in
/dev, and make life unnecessarily hard for user-space applications:
instead of checking for existence, they'd have to check that all the
devices work.  I doubt systemd will accept such a patch, just to bend
over backwards and support um.
