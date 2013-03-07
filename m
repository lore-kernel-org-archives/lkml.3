Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129Ab3CGOLZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 09:11:25 -0500
Received: from mail.green-internet.de ([213.252.188.14]:41020 "EHLO
	mail.green-internet.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753674Ab3CGOLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 09:11:23 -0500
Message-ID: <5138A00F.8060806@draisberghof.de>
Date: Thu, 07 Mar 2013 15:11:27 +0100
From: Josua Dietze <digidietze@draisberghof.de>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: =?UTF-8?B?QmrDuHJuIE1vcms=?= <bjorn@mork.no>
CC: "Fangxiaozhi (Franko)" <fangxiaozhi@huawei.com>,
        Dan Williams <dcbw@redhat.com>, Greg KH <gregkh@linuxfoundation.org>,
        "Linlei (Lei Lin)" <lei.lin@huawei.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Xueguiying (Zihan)" <zihan.xue@huawei.com>,
        "Yili (Neil)" <neil.yi@huawei.com>, Wangyuhua <yuhua.wang@huawei.com>,
        "Huqiao (C)" <huqiao36@huawei.com>, "balbi@ti.com" <balbi@ti.com>,
        "mdharm-usb@one-eyed-alien.net" <mdharm-usb@one-eyed-alien.net>,
        "sebastian@breakpoint.cc" <sebastian@breakpoint.cc>,
        stable <stable@vger.kernel.org>
Subject: Re: =?UTF-8?B?562U5aSNOiBbUEFUQ0hdIFVTQjogc3RvcmFnZTogZml4IEh1YXc=?=
 =?UTF-8?B?ZWkgbW9kZSBzd2l0Y2hpbmcgcmVncmVzc2lvbg==?=
References: <87obezs888.fsf@nemi.mork.no> <1362403161-23501-1-git-send-email-bjorn@mork.no> <910F9D9E13B84F4C8FA771DC9BDE99F32709833E@szxeml546-mbx.china.huawei.com> <8738waqhx2.fsf@nemi.mork.no> <43F99538ECE41341993F359D4AA4FB5F4B3783F2@szxeml560-mbs.china.huawei.com> <20130306014424.GA8408@kroah.com> <1362584750.21968.1.camel@dcbw.foobar.com> <910F9D9E13B84F4C8FA771DC9BDE99F32709E060@szxeml546-mbx.china.huawei.com> <87haknjtbl.fsf@nemi.mork.no>
In-Reply-To: <87haknjtbl.fsf@nemi.mork.no>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 07.03.2013 13:19, schrieb Bjørn Mork:
> it looks like your app will need to be a member of the "usb" group to do
> this.  I assume there is a way for an app to request such permissions in
> Android.  Josh has obviously managed to get it.

Actually, the PPP Widget app requires access to a root shell because it is intended for user installation; however, for a system integrator it should not be hard to add a system app that handles USB devices.

Device discovery is provided by Android since 3.1, permitting device handling in place of an udev system.

A completely different question is if tablet manufacturers are keen on making their Wifi-only devices ready for 3G data via USB devices. It may conflict with their business interests if they are offering 3G-enabled devices for an extra charge.

They may come to the conclusion to patch out the 'huawei_init' feature altogether.


Josua Dietze

