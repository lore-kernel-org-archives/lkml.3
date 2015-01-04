Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752636AbbADKCu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 05:02:50 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:50295 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbbADKCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 05:02:48 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CAE8XmWo-fOG1jEFPD4oFbR68Oaky+cUwvgVzEar2cfH7k4c1xQ@mail.gmail.com>
References: <CA+icZUUkp4OrPWfw7PEpt2DDEyrf+z1SAQcXpREOXoA7JQ0stg@mail.gmail.com>
	<CA+icZUV8Zu=fE5Jj-Fo5a3TTz-C2r2L5zWJzEcrfSbdq5Zf4sA@mail.gmail.com>
	<CAE8XmWo-fOG1jEFPD4oFbR68Oaky+cUwvgVzEar2cfH7k4c1xQ@mail.gmail.com>
Date: Sun, 4 Jan 2015 11:02:46 +0100
Message-ID: <CA+icZUVwmQkArRF2mtnF_JrTE8tueuejesawF-gu4xzKddpSTQ@mail.gmail.com>
Subject: Re: libaio tarballs on <kernel.org>
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Dongsheng Song <dongsheng.song@gmail.com>
Cc: Jeff Moyer <jmoyer@redhat.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Guillem Jover <guillem@debian.org>, linux-aio <linux-aio@kvack.org>,
        Benjamin LaHaise <bcrl@kvack.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 4, 2015 at 9:55 AM, Dongsheng Song <dongsheng.song@gmail.com> wrote:
> On Sun, Jan 4, 2015 at 4:21 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>> I have also seen... with outdated material?
>>
>
> we can use syscall.h and aio_abi.h directly.
>
> IMHO, I think libaio is of little value. It's just simple wrappers of
> aio syscall and some useful macros. It will useful only when it
> implement posix aio api, but this only on the roadmap.

Thanks for your feedback.

The background of my asking was that I wanted a higher version of
libaio-dev which is a prereq for fio on Ubuntu/precise for my tests
with loop-mq feature.

Cannot say if it is possible to build with syscall.h and aio_abi.h
directly (shipped with the Linux-kernel sources which might change
from release to release).

- Sedat -
