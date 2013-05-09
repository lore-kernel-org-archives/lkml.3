Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755763Ab3EIBZj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 21:25:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55302 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755623Ab3EIBZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 21:25:38 -0400
MIME-Version: 1.0
In-Reply-To: <s5hsj1xxsv2.wl%tiwai@suse.de>
References: <1367996197-32748-1-git-send-email-tiwai@suse.de>
	<1367996197-32748-2-git-send-email-tiwai@suse.de>
	<CACVXFVM2ZFYeJND7nxGhyGU7cG08Hta5qBZMAz+rDhxM1kRWZA@mail.gmail.com>
	<s5hd2t1wih4.wl%tiwai@suse.de>
	<s5h38txwhqq.wl%tiwai@suse.de>
	<s5hsj1xxsv2.wl%tiwai@suse.de>
Date: Thu, 9 May 2013 09:25:35 +0800
Message-ID: <CACVXFVPH1W8ogaus49WNyU17xcbbZ=_2F2FD4Yv_DJcdDov8EQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] firmware: Avoid superfluous usermodehelper lock
From: Ming Lei <ming.lei@canonical.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 9, 2013 at 1:51 AM, Takashi Iwai <tiwai@suse.de> wrote:
>> In other words, the first patch is no essential part of the fix.
>> I can revisit the second patch without this one and resend if
>> preferred.
>
> FWIW, below is the revised patch.
> It's alone without the patch 1 in the previous series.

The root cause is that your user space loader doesn't follow the
current firmware loader interface.

IMO, the patch is unnecessary since we already have the timeout
abort(just need one patch to enable it for nowait api)

Thanks,
--
Ming Lei
