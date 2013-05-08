Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758378Ab3EHQFr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 12:05:47 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:33021 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758361Ab3EHQFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 12:05:45 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFweu3tVnt-1=G8cx_Xi+_3X7DFvPv0qHbdBptD3Tm6ztg@mail.gmail.com>
References: <20130508145023.GN7800@kernel.dk>
	<CA+55aFy1z6bcEt5pOd3O58Mx9dk00uDxROcDCS+QUybLbMMh4Q@mail.gmail.com>
	<20130508151126.GP7800@kernel.dk>
	<CA+55aFweu3tVnt-1=G8cx_Xi+_3X7DFvPv0qHbdBptD3Tm6ztg@mail.gmail.com>
Date: Wed, 8 May 2013 09:05:45 -0700
X-Google-Sender-Auth: 2pqibRZALNOnUttJvSZg7jdOEtA
Message-ID: <CA+55aFwKUVW4xe5eVToORXYkJ0bkACdcwfE=g8oaZeYPxAjUoA@mail.gmail.com>
Subject: Re: [GIT PULL] Block IO core changes for 3.10
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 8, 2013 at 9:03 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Wed, May 8, 2013 at 8:11 AM, Jens Axboe <axboe@kernel.dk> wrote:
>>
>> Frankly the pull is just late since I have been busy with that and
>> company bits. If you look at the history, there's been no changes in
>> more than a week.
>
> Ok, good. The timing made me nervous..

Oh, and should I made BIO_RESET_BITS and BIO_OWNS_VEC be 13? We have a
new BIO_SNAP_STABLE that is 12, and I'm really hoping these values
aren't exposed anywhere to users..

            Linus
