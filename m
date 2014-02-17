Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021AbaBQRym (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 12:54:42 -0500
Received: from mail-ve0-f179.google.com ([209.85.128.179]:35384 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752679AbaBQRyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 12:54:41 -0500
MIME-Version: 1.0
In-Reply-To: <s5hk3cxzce0.wl%tiwai@suse.de>
References: <CAAJw_ZvX2AfS8COiNdN9gi_1xJ4L_vL=ROCzcLL3u0h51kuX3Q@mail.gmail.com>
	<52FCFD92.7040109@hurleysoftware.com>
	<s5hiosi3osp.wl%tiwai@suse.de>
	<CAAJw_ZsoO=kd6cVM3HYrkim5K0RKrnDXYGgodNNQmHVYs19a8A@mail.gmail.com>
	<s5hha8123vu.wl%tiwai@suse.de>
	<CAAJw_ZtviRCtaC4-3_ubkYuEt+LYstwbi6qus-5GOoOLYhfecw@mail.gmail.com>
	<s5hk3cxzce0.wl%tiwai@suse.de>
Date: Tue, 18 Feb 2014 01:54:40 +0800
Message-ID: <CAAJw_ZtK+jTOhCPZKhCu_f2nHwUahE8jcR8G4+FbocEc66Ei4g@mail.gmail.com>
Subject: Re: Lenovo X240 (haswell) suspend-to-ram hangs on 3-14.0-rc2
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Peter Hurley <peter@hurleysoftware.com>,
        lkml <linux-kernel@vger.kernel.org>, Dave Airlie <airlied@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 15, 2014 at 4:07 AM, Takashi Iwai <tiwai@suse.de> wrote:

>> # bad
>> CONFIG_SND_HDA_CODEC_HDMI =y
>> CONFIG_SND_HDA_INTEL=y
>> CONFIG_SND_HDA_INPUT_BEEP=y
 CONFIG_SND_HDA_GENERIC=m
>
> It might be the remaining bugs of modularization in 3.14-rc2.
> A few patches are found in for-linus branch of sound git tree, which
> are included in Today's pull request.  Could you give it a try?

Pulled, but still the same. Modularized works fine -- even the modules
remains, s2r works. But setting to "Yes" ... won't suspend. I don't
kow how to capture those errors above the screens :(

Any suggestion on how to debug this? bisect? Ted, does your T540p work
with CONFIG_SND_HDA_INTEL=y instead of "m" ?

Thanks,
Jeff
