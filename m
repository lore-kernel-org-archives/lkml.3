Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927AbaGJSAJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 14:00:09 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:49788 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438AbaGJSAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 14:00:07 -0400
MIME-Version: 1.0
In-Reply-To: <20140709182651.GB15932@console-pimps.org>
References: <1402773821-15995-1-git-send-email-yinghai@kernel.org>
	<20140618142819.GN24049@console-pimps.org>
	<20140709182651.GB15932@console-pimps.org>
Date: Thu, 10 Jul 2014 11:00:06 -0700
X-Google-Sender-Auth: a1oSXIUoQeKUbTo_s6Nu2hq57q4
Message-ID: <CAE9FiQVP6d5GhFBBmX5HDo0w0oKJSizdKvepq5t6vhGNj=W9sg@mail.gmail.com>
Subject: Re: [PATCH] x86, eboot: Support initrd loaded above 4G
From: Yinghai Lu <yinghai@kernel.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: Matt Fleming <matt.fleming@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, linux-efi@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 9, 2014 at 11:26 AM, Matt Fleming <matt@console-pimps.org> wrote:
> On Wed, 18 Jun, at 03:28:19PM, Matt Fleming wrote:
>> On Sat, 14 Jun, at 12:23:41PM, Yinghai Lu wrote:
>> > For boot efi kernel directly without bootloader.
>> > If the kernel support XLF_CAN_BE_LOADED_ABOVE_4G, we should
>> > not limit initrd under hdr->initrd_add_max.
>
> Well, fooey. This patch breaks one of my ASUS machines. It appears some
> firmware implementations exhibit issues reading directly into a buffer
> above the 4GB mark.
>
> I haven't diagnosed exactly what goes wrong with the buffer (i.e. in
> what way it becomes corrupt), but I should really do that before
> thinking of how to fix this.
>
> I'll keep you posted, I just wanted to give you a heads up that things
> are screwy in this area.

Oh, no.

so efi could allocate buffer above 4g but can not access it?

Yinghai
