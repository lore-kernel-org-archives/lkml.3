Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994AbaILKsF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 06:48:05 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:40181 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252AbaILKsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 06:48:03 -0400
MIME-Version: 1.0
In-Reply-To: <20140912112619.50d3b651@www.etchedpixels.co.uk>
References: <CAPM=9tyZF2S7PJcLyc=KH_NBFXju8UwvMBOF_MocNK8pPVXDYw@mail.gmail.com>
	<20140912112619.50d3b651@www.etchedpixels.co.uk>
Date: Fri, 12 Sep 2014 20:48:01 +1000
Message-ID: <CAPM=9tzuHQxPYoUZegKzwUoHBvp1UTkmtV3zcBmUxeJUr9qAWA@mail.gmail.com>
Subject: Re: vga and 64-bit memcpy's
From: Dave Airlie <airlied@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 September 2014 20:26, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Fri, 12 Sep 2014 13:57:20 +1000
> Dave Airlie <airlied@gmail.com> wrote:
>
>> Got an bug report from someone using a silicon motion video card in
>> VGA mode about corruption that they tracked down to 64-bit memory
>> operations not being supported by the video card, it appears that we
>> probably shouldn't be using > 32-bit copies on VGA memory.
>
> VGA memory is write combining usually so the answer in general would be
> no. You may also find its a combination of bridge and card and one or the
> other is somehow out of spec.

Well I'm not shocked that an SMI GPU is out of spec, just not sure how
we can workaround it.

Dave.
