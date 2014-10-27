Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557AbaJ0QLJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 12:11:09 -0400
Received: from mail-oi0-f49.google.com ([209.85.218.49]:54811 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213AbaJ0QLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 12:11:07 -0400
MIME-Version: 1.0
In-Reply-To: <54481091.3030306@gmx.de>
References: <1413881397.30379.7.camel@hadess.net>
	<loom.20141021T140216-28@post.gmane.org>
	<54481091.3030306@gmx.de>
Date: Mon, 27 Oct 2014 20:11:06 +0400
X-Google-Sender-Auth: 7W8BvFlUwPY_FKIv3nKCWr1oovY
Message-ID: <CABaUXi46XfhAAV27=09A1HPXCEMj5s67ckgRCgpQt6=qY-uOjg@mail.gmail.com>
Subject: Re: A desktop environment[1] kernel wishlist
From: "Sergey \"Shnatsel\" Davidoff" <sergey@elementaryos.org>
To: Heinrich Schuchardt <xypron.glpk@gmx.de>
Cc: linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Bastien Nocera <hadess@hadess.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> When I read your wish, I guess adding the capability to watch mounts with
> inotify would satisfy your needs. Would you agree?

The problem with inotify is that it's very inefficient for monitoring
hundreds of thousands of files, which is a fairly common case on the
desktop. I cannot see how support for watching mounts would fix that.

-- 
Sergey "Shnatsel" Davidoff
