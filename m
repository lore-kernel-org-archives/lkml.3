Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751460Ab3BFIIr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 03:08:47 -0500
Received: from mail-vc0-f172.google.com ([209.85.220.172]:52109 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755Ab3BFIIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 03:08:44 -0500
MIME-Version: 1.0
In-Reply-To: <5111E44C.2040308@zytor.com>
References: <cover.1360067333.git.dmitry.kasatkin@intel.com>
	<cc87f1242960fad1a9fb44bcec331915e14c832b.1360067333.git.dmitry.kasatkin@intel.com>
	<20130205203616.GA8228@fenchurch.internal.datastacks.com>
	<CALLzPKaTExm=eJ_f4x4NUROk83wDHQy0osexd4QqvHODd9ZPwA@mail.gmail.com>
	<5111E44C.2040308@zytor.com>
Date: Wed, 6 Feb 2013 10:01:12 +0200
Message-ID: <CALLzPKZRiWR1gBt4x9PM0pzAB6KVaE0ViEjLJLdVYk+==SSjHQ@mail.gmail.com>
Subject: Re: [RFC 2/2] initramfs with digital signature protection
From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Jones <pjones@redhat.com>, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 6, 2013 at 7:04 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 02/05/2013 02:09 PM, Kasatkin, Dmitry wrote:
>>
>>
>> It should not be like that. Actually when pre-init exits, cleanup code
>> umount tmpfs, which in turn cleanups the RAM.
>>
>
> It doesn't quite... the rootfs is permanent.  This is also only one usage
> mode: there are quite a few Linux systems running directly out of initramfs.
>

rootfs is not permanent when it is ramfs. It is cleaned up on switch root.
It is easy to find out that it is empty by mounting : mount -t ramfs
rootfs /mnt/

In the case of running from normal storage, of course, there is
ridicules remove the content.

- Dmitry


>         -hpa
>
>
> --
> H. Peter Anvin, Intel Open Source Technology Center
> I work for Intel.  I don't speak on their behalf.
>
