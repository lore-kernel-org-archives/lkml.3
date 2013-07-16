Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879Ab3GPJtW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 05:49:22 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:3860 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754545Ab3GPJtU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 05:49:20 -0400
X-Server-Uuid: B86B6450-0931-4310-942E-F00ED04CA7AF
Message-ID: <51E51712.4020609@broadcom.com>
Date: Tue, 16 Jul 2013 11:49:06 +0200
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623
 Thunderbird/17.0.7
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Ortwin_Gl=FCck?= <odi@odi.ch>
cc: "Stanislaw Gruszka" <sgruszka@redhat.com>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: Re: [BUG] 3.10 regression: hang on suspend
References: <51E4501D.3010001@odi.ch> <20130716065626.GA1587@redhat.com>
 <51E4F790.6090308@odi.ch>
In-Reply-To: <51E4F790.6090308@odi.ch>
X-WSS-ID: 7DFBCB5F2L848902545-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2013 09:34 AM, Ortwin Glück wrote:
>
>
> On 16.07.2013 08:56, Stanislaw Gruszka wrote:
>> Apparently this commit changed suspend procedure on mac80211, but it's
>> not obvious for me why it hangs :-(
>
> Hangs are hard :-) It just sits there with a black screen and a white
> cursor in the top left corner...
>
>> What is your user space configuration (are you using NM or other
>> software or maybe just wpa_supplicant)? Are you using wowlan?
>> If you do add no_console_suspend boot parameter does it print some
>> diagnostic messages during suspend before the hang ?
>
> Yes, I am using NM under KDE, with KDE triggered suspend. No wowlan
> AFAIK. The last thing I see in the log is something from NetworkManager
> that sees the device switching off. I can try again tonight and give you
> the exact message.
>
> I will also try without NM and bare wpa_supplicant and a plain suspend
> through sysfs.
>
> Any debug options you want me to enable? Netconsole won't work however...

Can you get more debug info if you try (as root/sudo -i):

echo devices > /sys/power/pm_test
echo mem > /sys/power state

Regards,
Arend

> Ortwin
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


