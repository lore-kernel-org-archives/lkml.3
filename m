Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752459AbbADI4B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 03:56:01 -0500
Received: from mail-oi0-f46.google.com ([209.85.218.46]:55159 "EHLO
	mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbbADIz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 03:55:59 -0500
MIME-Version: 1.0
In-Reply-To: <CA+icZUV8Zu=fE5Jj-Fo5a3TTz-C2r2L5zWJzEcrfSbdq5Zf4sA@mail.gmail.com>
References: <CA+icZUUkp4OrPWfw7PEpt2DDEyrf+z1SAQcXpREOXoA7JQ0stg@mail.gmail.com>
 <CA+icZUV8Zu=fE5Jj-Fo5a3TTz-C2r2L5zWJzEcrfSbdq5Zf4sA@mail.gmail.com>
From: Dongsheng Song <dongsheng.song@gmail.com>
Date: Sun, 4 Jan 2015 16:55:38 +0800
Message-ID: <CAE8XmWo-fOG1jEFPD4oFbR68Oaky+cUwvgVzEar2cfH7k4c1xQ@mail.gmail.com>
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

On Sun, Jan 4, 2015 at 4:21 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> I have also seen... with outdated material?
>

we can use syscall.h and aio_abi.h directly.

IMHO, I think libaio is of little value. It's just simple wrappers of
aio syscall and some useful macros. It will useful only when it
implement posix aio api, but this only on the roadmap.
