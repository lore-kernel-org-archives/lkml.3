Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778AbaAKTln (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 14:41:43 -0500
Received: from mail-ee0-f51.google.com ([74.125.83.51]:56137 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879AbaAKTlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 14:41:40 -0500
Message-ID: <52D19EB8.9060405@googlemail.com>
Date: Sat, 11 Jan 2014 20:42:48 +0100
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: Tejun Heo <tj@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: sysfs warnings since kernel 3.13-rc1: "WARNING: ... at fs/sysfs/group.c:214
 sysfs_remove_group"
References: <52CC3D1A.9050109@googlemail.com> <20140107175925.GC3231@htj.dyndns.org> <52CDAEA2.2000801@googlemail.com> <20140108183258.01c494e4@samsung.com>
In-Reply-To: <20140108183258.01c494e4@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 08.01.2014 21:32, schrieb Mauro Carvalho Chehab:
> With the patches that split em28xx-v4l from the main em28xx, this logic
> changed, as em28xx_release_analog_resources() now have another name and
> don't free em28xx dev anymore.
>
> Could you please test again after that patches?
Yes, I've tested it and the warnings are still there.
However, I just started to rework the whole em28xx resources releasing
logic and I think I know how to fix these warnings.

Regards,
Frank

