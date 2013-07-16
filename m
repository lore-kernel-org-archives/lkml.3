Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933622Ab3GPRHI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 13:07:08 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:33298 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933446Ab3GPRHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 13:07:06 -0400
MIME-Version: 1.0
In-Reply-To: <51E57BC1.4090904@nod.at>
References: <1373993525-25629-1-git-send-email-artagnon@gmail.com> <51E57BC1.4090904@nod.at>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Tue, 16 Jul 2013 22:36:25 +0530
Message-ID: <CALkWK0nrDsZiHe2==DQZuHV7id=6gc4UHUj1xXu9jN5cr3SUcQ@mail.gmail.com>
Subject: Re: [PATCH] um/configs: don't use devtmpfs in defconfig
To: Richard Weinberger <richard@nod.at>
Cc: LKML <linux-kernel@vger.kernel.org>, Jeff Dike <jdike@addtoit.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Weinberger wrote:
> If you don't want devtmpfs, just disable it in your config.

I don't understand: is this not a good default?  Why is creating bogus
devices, confusing systemd, and making um Linux hard to boot
desirable?
