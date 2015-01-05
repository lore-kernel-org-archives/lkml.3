Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143AbbAEBuX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 20:50:23 -0500
Received: from mail-ob0-f175.google.com ([209.85.214.175]:53166 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773AbbAEBuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 20:50:22 -0500
MIME-Version: 1.0
In-Reply-To: <CA+icZUVwmQkArRF2mtnF_JrTE8tueuejesawF-gu4xzKddpSTQ@mail.gmail.com>
References: <CA+icZUUkp4OrPWfw7PEpt2DDEyrf+z1SAQcXpREOXoA7JQ0stg@mail.gmail.com>
 <CA+icZUV8Zu=fE5Jj-Fo5a3TTz-C2r2L5zWJzEcrfSbdq5Zf4sA@mail.gmail.com>
 <CAE8XmWo-fOG1jEFPD4oFbR68Oaky+cUwvgVzEar2cfH7k4c1xQ@mail.gmail.com> <CA+icZUVwmQkArRF2mtnF_JrTE8tueuejesawF-gu4xzKddpSTQ@mail.gmail.com>
From: Dongsheng Song <dongsheng.song@gmail.com>
Date: Mon, 5 Jan 2015 09:50:00 +0800
Message-ID: <CAE8XmWozzc1nEFJZ+DrqeSJHvK=aHULVnDVMB9cRftLfznsfXA@mail.gmail.com>
Subject: Re: libaio tarballs on <kernel.org>
To: sedat.dilek@gmail.com
Cc: Jeff Moyer <jmoyer@redhat.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Guillem Jover <guillem@debian.org>, linux-aio <linux-aio@kvack.org>,
        Benjamin LaHaise <bcrl@kvack.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 4, 2015 at 6:02 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> Cannot say if it is possible to build with syscall.h and aio_abi.h
> directly (shipped with the Linux-kernel sources which might change
> from release to release).
>
> - Sedat -

It's user space api, it's stable, will not changed.
