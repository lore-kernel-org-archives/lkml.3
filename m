Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751053AbaK0PyZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 10:54:25 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:44463 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbaK0PyX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 10:54:23 -0500
MIME-Version: 1.0
In-Reply-To: <CAJZww4gzTnbyB4jbFQc0N4G6GJ31pVwv-PNZtDMbUxXMoH-orQ@mail.gmail.com>
References: <1417075250-6502-1-git-send-email-phillip@squashfs.org.uk>
	<20141127133754.GA12750@wolff.to>
	<CAJZww4gzTnbyB4jbFQc0N4G6GJ31pVwv-PNZtDMbUxXMoH-orQ@mail.gmail.com>
Date: Thu, 27 Nov 2014 15:54:22 +0000
Message-ID: <CAJZww4hiVq2rTaxxZnGdUFsk+auvX6qvVOgCqHH=dnVdGbJSqw@mail.gmail.com>
Subject: Fwd: [PATCH 0/2] Squashfs: add LZ4 compression
From: Marcin Szychowski <szycha@gmail.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---------- Forwarded message ----------
From: Marcin Szychowski <szycha@gmail.com>
Date: 2014-11-27 15:50 GMT+00:00
Subject: Re: [PATCH 0/2] Squashfs: add LZ4 compression
To: Bruno Wolff III <bruno@wolff.to>
Cc: Phillip Lougher <phillip@squashfs.org.uk>,
linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
texstar@gmail.com, martin@mvath.de, guanx.bac@gmail.com,
dave@vasilevsky.ca, blyons@students.naropa.edu, tokiclover@gmail.com,
afm404@gmail.com, hugochevrain@gmail.com


2014-11-27 13:37 GMT+00:00 Bruno Wolff III <bruno@wolff.to>:
>
> On Thu, Nov 27, 2014 at 08:00:47 +0000,
>  Phillip Lougher <phillip@squashfs.org.uk> wrote:
>>
>>
>> My intention is to submit them in the next kernel merge window.
>> If you want LZ4 support in Squashfs now is a good time to publically
>> support the inclusion of these patches.
>
>
> Fedora has been supporting LZ4 functionallity in mksquashfs and unsquashfs for about 6 months (in F19+), but the Fedora kernel team won't add support in the kernel until LZ4 support is accepted for the upstream kernel.

Hello everyone,

Squashfs is awesome piece of code.  It’s potential usage pattern
analysis could turn into pretty decent PhD thesis – from simple
archival purposes through embedded systems, to dynamic nearly-instant
multi-server software deployment systems, and many others.

On the other hand, LZ4 is fantastic compression algorithm with
well-known list of advantages.

As I wrote to Phillip earlier, I have been using squashfs+lz4 / aufs
to speed up my laptop (and reclaim some space, too).  That would not
be possible without LZ4: I could have gain some speed with LZO or disk
space with gzip or xz, but not both.  LZ4 is comparable with LZO in
terms of decompression speed and with gzip in terms of compression
ratios.  LZ4 is much faster in both compression and in particular
decompression speed than gzip (1-9) and xz (1-9).  It is just the best
choice for many storage-related purposes (see ZFS on Linux
[https://github.com/zfsonlinux/zfs/commit/9759c60f1a1503e48dc5c45a209c3edd5758319f]
and [http://wiki.illumos.org/display/illumos/LZ4+Compression])

I don’t quite get why does anyone need to be convinced to merge
advantages of two fine pieces of code, since both have been already in
the mainline kernel for some time now.  It’s like being forced to
choose between big car and safe car, or delicious food and
good-looking food.

It is not about forcing anyone to use something, it is about ease of choice.

Having squashfs with lz4 in mainline kernel sounds like next natural
step.  Please do not hesitate to take it.


-- 
Regards,
Marcin Szychowski

+48.791460067
http://adastor.pl
