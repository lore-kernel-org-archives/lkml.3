Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851Ab3IKGLE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 02:11:04 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:42854 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819Ab3IKGLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 02:11:01 -0400
MIME-Version: 1.0
Reply-To: andrea.merello@gmail.com
In-Reply-To: <522F584E.6000806@lwfinger.net>
References: <CAN8YU5NTKUtS8+YzmcOSM3=YUX-FSwLTD86F_hXsNdVkw5NEGA@mail.gmail.com>
	<522F584E.6000806@lwfinger.net>
Date: Wed, 11 Sep 2013 08:11:00 +0200
Message-ID: <CAN8YU5PCFj-gtQwuuR3fM52YAVTi_5NYPbDVj-KMSzMpXjvFWQ@mail.gmail.com>
Subject: Re: RTL8187SE staging Linux driver
From: Andrea Merello <andrea.merello@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: wlanfae@realtek.com, shwei <shwei@realtek.com.tw>,
        John Linville <linville@tuxdriver.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <greg@kroah.com>, linux-wireless@vger.kernel.org,
        Michael Wu <flamingice@sourmilk.net>,
        Bernhard Schiffner <bernhard@schiffner-limbach.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for your code and for documentation!

I see you did your work in a new net/wireless/rtl818x/rtl8187se
directory and you produced a new driver.
Now I have to evaluate whether to keep doing it in this way, trying to
continue your work, or to merge support in
net/wireless/rtl818x/rtl8180 code, that was my original idea..
Now that I have documentation I can better evaluate how much the two
boards are similar..

Andrea

On Tue, Sep 10, 2013 at 7:35 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> On 09/10/2013 10:59 AM, Andrea Merello wrote:
>>
>> Hello,
>>
>> As you probably know, in the current Linux kernel there is a staging
>> driver for the RTL8187SE device (based on my older RTL8180/RTL8185
>> Linux driver), while there also a regular (not staging) driver
>> supporting older RTL8185 and RTL8180 devices
>> (net/wireless/rtl818x/rtl8180) .
>>
>> As far as I can see, the RTL8187SE device seems not so much different
>> from an RTL8185 device.
>> I would like to try (in my spare time) to add support for RTL8187SE
>> device in the current RTL818x driver, in order to avoid code
>> duplication, remove a driver from staging, and make RTL8187SE using
>> mac80211.
>>
>> Do any one of you have any comment/objection/suggestions about this ?
>>
>> Is it possible to get the RTL8187SE documentation to make things easier?
>>
>> For now I will probably keep different RF code for the two cards even
>> if the RTL8225 (zebra 2) radio is used by both RTL8187SE and some
>> RTL8185 devices, however if I could get enough documentation about it,
>> it would be great to try to merge also RF code..
>
>
> I too would be very happy for you to do this. At one point, I was trying to
> do this and I had a version that very nearly worked. The driver was
> receiving data and transmitting short packets but failing on longer ones.
> Length 42 was OK, but 68 failed. At that point, the chip locked up and
> needed to be power cycled. It seems that I got the DMA wrong, but I could
> never find it, and eventually, I had to move on.
>
> At the moment, I am working at getting it to build on the current kernel.
> When I finish that, I will send the code to you. Even if you decide to scrap
> it, it may help you a little.
>
> Attached is the datasheet, which is the only documentation I have.
>
> Larry
>
>
