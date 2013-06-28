Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316Ab3F1KAD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 06:00:03 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:56186 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755043Ab3F1J77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 05:59:59 -0400
MIME-Version: 1.0
In-Reply-To: <51C8ECC7.4030404@mit.edu>
References: <1372112849-670-1-git-send-email-dh.herrmann@gmail.com>
	<1372112849-670-4-git-send-email-dh.herrmann@gmail.com>
	<51C8ECC7.4030404@mit.edu>
Date: Fri, 28 Jun 2013 11:59:58 +0200
Message-ID: <CANq1E4SA4vW3fNRt2c6BV31w0MK8RV7F0CTCuq03y-ko_s2kSg@mail.gmail.com>
Subject: Re: [RFC 3/6] drm: add SimpleDRM driver
From: David Herrmann <dh.herrmann@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Dave Airlie <airlied@gmail.com>, linux-fbdev@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>, Olof Johansson <olof@lixom.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Tue, Jun 25, 2013 at 3:05 AM, Andy Lutomirski <luto@amacapital.net> wrote:
> On 06/24/2013 03:27 PM, David Herrmann wrote:
>> +     sdrm->fb_map = ioremap(sdrm->fb_base, sdrm->fb_size);
>
> This should probably be ioremap_wc.  Otherwise it will be *really* slow
> if used in legacy mode and it may cause conflicts with the
> pgprot_writecombine mode for mmap.

Whoops, yepp, I fixed that.

Thanks
David
