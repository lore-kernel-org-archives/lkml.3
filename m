Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934493Ab3CHROT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 12:14:19 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:50637 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759809Ab3CHROO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 12:14:14 -0500
MIME-Version: 1.0
In-Reply-To: <20130220173130.GA30757@joana>
References: <20130219165415.GE362@hansolo.jdub.homelinux.org>
	<20130220173130.GA30757@joana>
Date: Fri, 8 Mar 2013 10:14:12 -0700
Message-ID: <CAKocOOON6HCtz8v8HEb3+HjL6ouMNLPEJ3YjqfHW_i3NwJ=A7w@mail.gmail.com>
Subject: Re: [PATCH] bluetooth: Add support for atheros 04ca:3004 device to ath3k
From: Shuah Khan <shuahkhan@gmail.com>
To: Gustavo Padovan <gustavo@padovan.org>, Josh Boyer <jwboyer@redhat.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        niktr@mail.ru
Cc: Greg KH <gregkh@linuxfoundation.org>, "\"stable" <stable@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2013 at 10:31 AM, Gustavo Padovan <gustavo@padovan.org> wrote:
> Hi Josh,
>
> * Josh Boyer <jwboyer@redhat.com> [2013-02-19 11:54:16 -0500]:
>
>> Yet another version of the atheros bluetooth chipset
>>
>> T:  Bus=01 Lev=02 Prnt=02 Port=03 Cnt=01 Dev#=  3 Spd=12  MxCh= 0
>> D:  Ver= 1.10 Cls=e0(wlcon) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
>> P:  Vendor=04ca ProdID=3004 Rev=00.01
>> S:  Manufacturer=Atheros Communications
>> S:  Product=Bluetooth USB Host Controller
>> S:  SerialNumber=Alaska Day 2006
>> C:  #Ifs= 2 Cfg#= 1 Atr=e0 MxPwr=100mA
>> I:  If#= 0 Alt= 0 #EPs= 3 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
>> I:  If#= 1 Alt= 0 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
>>
>> This resolves https://bugzilla.redhat.com/show_bug.cgi?id=844750
>>
>> Reported-by: niktr@mail.ru
>> Signed-off-by: Josh Boyer <jwboyer@redhat.com>
>> ---
>>  drivers/bluetooth/ath3k.c | 2 ++
>>  drivers/bluetooth/btusb.c | 1 +
>>  2 files changed, 3 insertions(+)
>
> Patch has been applied to bluetooth.git. Thanks.
>
>         Gustavo

Gustavo,

I don't see this in Linus's git? Do you plan to get this into 3.9? Do
you consider this a candidate for stable releases?

thanks,
-- Shuah
