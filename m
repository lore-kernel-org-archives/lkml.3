Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757323AbaIIPYH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 11:24:07 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:52742 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757282AbaIIPYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 11:24:04 -0400
MIME-Version: 1.0
In-Reply-To: <1410240056-22786-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1410240056-22786-1-git-send-email-ricardo.ribalda@gmail.com>
Date: Tue, 9 Sep 2014 08:24:02 -0700
Message-ID: <CAMo8BfJRO+dwMVDJiQ4KH0PdJN604YrrZZUdSK35KumE574uyg@mail.gmail.com>
Subject: Re: [PATCH 2/2] xtensa/uapi: Add definition of TIOC[SG]RS485
From: Max Filippov <jcmvbkbc@gmail.com>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chris Zankel <chris@zankel.net>, LKML <linux-kernel@vger.kernel.org>,
        linux-serial@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 8, 2014 at 10:20 PM, Ricardo Ribalda Delgado
<ricardo.ribalda@gmail.com> wrote:
> Commit: e676253b19b2d269cccf67fdb1592120a0cd0676 [3/21] serial/8250: Add
> support for RS485 IOCTLs, adds support for RS485 ioctls for 825_core on
> all the archs. Unfortunaltely the definition of TIOCSRS485 and
> TIOCGRS485 was missing on the ioctls.h file
>
> Reported-by: kbuild test robot <fengguang.wu@intel.com>
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> ---
>  arch/xtensa/include/uapi/asm/ioctls.h | 2 ++
>  1 file changed, 2 insertions(+)

Acked-by: Max Filippov <jcmvbkbc@gmail.com>

If you want this patch to go through the xtensa tree please let me know,
I'll include it to my fixes branch then.

-- 
Thanks.
-- Max
