Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932419AbaA1WI4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 17:08:56 -0500
Received: from mail-qa0-f42.google.com ([209.85.216.42]:35603 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932176AbaA1WIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 17:08:54 -0500
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:c52e:4525:dc55:16f2]
In-Reply-To: <1390946665-2967-1-git-send-email-yinghai@kernel.org>
References: <1390946665-2967-1-git-send-email-yinghai@kernel.org>
Date: Tue, 28 Jan 2014 14:08:54 -0800
Message-ID: <CAOesGMifCTzHaK4TqKeGJ+Kup2XmcL7UGxZuQWB2V9dHboBr9A@mail.gmail.com>
Subject: Re: [PATCH] memblock: Add limit checking to memblock_virt_alloc
From: Olof Johansson <olof@lixom.net>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Kevin Hilman <khilman@linaro.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 28, 2014 at 2:04 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> In original bootmem wrapper for memblock, we have limit checking.
>
> Add it to memblock_virt_alloc, to address arm and x86 booting crash.
>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

Tested-by: Olof Johansson <olof@lixom.net>

Verified to resolve the crashes on boot on ARM.


-Olof
