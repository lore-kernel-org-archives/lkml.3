Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758027AbaEKItk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 04:49:40 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:50822 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754825AbaEKIti convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 04:49:38 -0400
MIME-Version: 1.0
Date: Sun, 11 May 2014 10:49:37 +0200
Message-ID: <CAJAFBLBjW3v_qmOiU+0V2AuwgOV2bXRGdZtpUAoDDJuq0ZtEKQ@mail.gmail.com>
Subject: Re: Please revert 400362f1d8dcfda3562e80e88cfc2a92cffaf9bf
From: Fubo Chen <fubo.chen@gmail.com>
To: =?UTF-8?Q?Niccol=C3=B2_Belli?= <darkbasic@linuxsystems.it>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Takashi Iwai <tiwai@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(adding Takashi Iwai)

On Thu, May 8, 2014 at 4:06 PM, Niccolò Belli <darkbasic@linuxsystems.it> wrote:
> Hi,
> Sorry for posting on linux-kernel but from my experience nobody ever looks
> at the kernel bug tracker and I would like to get it fixed before 3.15 gets
> released.
>
> https://bugzilla.kernel.org/show_bug.cgi?id=75671
>
> It's funny to read "Still no boot quirks are called, *so it might not work
> well on some devices*" in the commit description:
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=400362f1d8dcfda3562e80e88cfc2a92cffaf9bf
> Why does code known to be broken hit the Linus tree? Every new kernel
> release there is something broken to bisect, it doesn't matter if you wait
> for the stable release or not. That's frustrating for an end user.
>
> Thanks,
> Niccolò
