Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753706AbaHETWM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 15:22:12 -0400
Received: from mail-yh0-f41.google.com ([209.85.213.41]:64926 "EHLO
	mail-yh0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753377AbaHETWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 15:22:11 -0400
MIME-Version: 1.0
In-Reply-To: <s5htx5r53jl.wl%tiwai@suse.de>
References: <14048583172593@kroah.com>
	<8B2F6FFD0BD1E448853114367400A37306FD6FBBE9@BLRX7MCDC203.AMER.DELL.COM>
	<s5h38e9mg5v.wl%tiwai@suse.de>
	<8B2F6FFD0BD1E448853114367400A37306FD6FBBF8@BLRX7MCDC203.AMER.DELL.COM>
	<s5hy4w1l0s3.wl%tiwai@suse.de>
	<8B2F6FFD0BD1E448853114367400A37306FD6FBC06@BLRX7MCDC203.AMER.DELL.COM>
	<s5hpphdkyi6.wl%tiwai@suse.de>
	<8B2F6FFD0BD1E448853114367400A37306FD6FBDAB@BLRX7MCDC203.AMER.DELL.COM>
	<s5hoawvkimg.wl%tiwai@suse.de>
	<8B2F6FFD0BD1E448853114367400A37306FE07C773@BLRX7MCDC203.AMER.DELL.COM>
	<s5h7g3frmg7.wl%tiwai@suse.de>
	<8B2F6FFD0BD1E448853114367400A37306FE07CC64@BLRX7MCDC203.AMER.DELL.COM>
	<s5hlhrrizbq.wl%tiwai@suse.de>
	<8B2F6FFD0BD1E448853114367400A37306FE311D74@BLRX7MCDC203.AMER.DELL.COM>
	<CAL8zT=jDUyxjimFxBFk56q+B9VwZdnijrU9VF7LBm4X4mNKp+g@mail.gmail.com>
	<s5hvbq753w2.wl%tiwai@suse.de>
	<CAL8zT=jzFmPZ2jizrPXMGBwNReOnDw7wLHZDashavNBh9vhe2g@mail.gmail.com>
	<s5htx5r53jl.wl%tiwai@suse.de>
Date: Tue, 5 Aug 2014 13:22:10 -0600
Message-ID: <CAKocOOO+vahGqVtM-hE6Vp5P2vX83L+z+OVnP=ZHvE4nc9P-JQ@mail.gmail.com>
Subject: Re: patch "firmware loader: allow disabling of udev as firmware
 loader" added to driver-core tree
From: Shuah Khan <shuahkhan@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Jean-Michel Hautbois <jhautbois@gmail.com>, B_B_Singh@dell.com,
        Greg KH <gregkh@linuxfoundation.org>, Abhay_Salunke@dell.com,
        Arnd Bergmann <arnd@arndb.de>, kay@vrfy.org, ming.lei@canonical.com,
        Stefan Roese <sr@denx.de>, teg@jklm.no, Stuart_Hayes@dell.com,
        Srinivas_G_Gowda@dell.com, linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 5, 2014 at 10:01 AM, Takashi Iwai <tiwai@suse.de> wrote:
>> Yes, it worked, if the firmware was in the /lib/firmware directory.
>

ok it works when the firmware is in /lib/firmware. It sounds to me the
reason load fails when the firmware is under /sys/class/firmware is
fw_load_from_user_helper() returns -ENOENT when
CONFIG_FW_LOADER_USER_HELPER is disabled.

It would be nice to see the entire dmesg with debug enabled though.

-- Shuah
