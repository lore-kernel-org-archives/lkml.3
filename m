Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757689Ab3GWPFa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 11:05:30 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:56140 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754566Ab3GWPF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 11:05:28 -0400
Message-ID: <51EE9BB6.8000501@lwfinger.net>
Date: Tue, 23 Jul 2013 10:05:26 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: =?UTF-8?B?IlBhdWwgUm9sbGFuZCAo44Od44O844Or44O744Ot44Op44OzKSI=?= 
	<rol@witbe.net>
CC: Richard Genoud <richard.genoud@gmail.com>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: rtl8192cu: slow path warning
References: <20130611123814.GA9854@lnx-rg> <20130626142241.GA13107@lnx-rg> <51CB0E9C.50408@lwfinger.net> <CACQ1gAh+WjQZHo+_afZpzcwt1=KPM8VMBOe=YCHN_LEZu+jPNQ@mail.gmail.com> <20130723142907.53103aab@tux.DEF.witbe.net>
In-Reply-To: <20130723142907.53103aab@tux.DEF.witbe.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2013 07:29 AM, Paul Rolland (ポール・ロラン) wrote:
> Hello,
>
> On Thu, 27 Jun 2013 09:33:20 +0200
> Richard Genoud <richard.genoud@gmail.com> wrote:
>
>> Yes, of course, you can add my
>> Reported-by: Richard Genoud <richard.genoud@gmail.com>
>>
>> But the patch doesn't compile on my platform ( since I'm on ARM, I
>> haven't got a PCI bus, so rtlwifi/pci.c is not compiled ) :
>>
>> ERROR: "rtl_lps_change_work_callback"
>> [drivers/net/wireless/rtlwifi/rtlwifi.ko] undefined!
>
> Is that the reason why this patch is not yet in 3.10.x or 3.11-rcY ?
> I'm running a 3.10.1 with USB dongle including 8192CU, and I can see this
> warning when the machine starts.
> I've check 3.10.1, 3.10.2 and 3.11-rc3 source code, but this fix is not
> there. Is there a different fix that went in in 3.10.2 or 3.11-rc?

The reason that patch is not in mainline is that it takes time. If you want to 
have it, you can get the official patch from 
http://marc.info/?l=linux-wireless&m=137242880222442&w=2, or you need to 
implement kernels from the wireless-testing git tree, where it was added on June 
28 as commit bcfb879. My original patch included the following note for John 
Linville:

"Ideally, this patch should be pushed to the 3.10 stream; however, at this late 
time that is not possible. Please push it for 3.11 and the Cc to stable will get 
it into 3.10.X."

As you see, it was marked with a Cc for Stable, and it will be propagated to 
3.10 when it gets incorporated by Linus. I think I have done all that I can do 
for now.

If you want to lobby Linus to get stuff accepted faster, that is your 
prerogative; however, I could not recommend that action, and I certainly will 
never do anything like that.

Larry

