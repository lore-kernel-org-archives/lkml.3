Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752387Ab3GZF4l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 01:56:41 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:39795 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439Ab3GZF4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 01:56:40 -0400
MIME-Version: 1.0
In-Reply-To: <20130718101058.GG11251@arwen.pp.htv.fi>
References: <CA+k=oDzG+R-ei5WGxP8L1Od6VWTK9SgWcXHNjd89u6+b2bECkQ@mail.gmail.com>
 <20130715165209.GA6000@kroah.com> <CA+k=oDzZ5sf_wFMUvE_vkkqRQaOV0P3vWP99tDpoZkrwMN7Q+A@mail.gmail.com>
 <20130716063117.GA30320@kroah.com> <20130717075706.GC5291@arwen.pp.htv.fi>
 <CA+k=oDza-oN++KCYtVMD0V62xgkJ3ctUOmzNkaYYYhXuKtaWKQ@mail.gmail.com>
 <20130717132736.GA7614@arwen.pp.htv.fi> <CA+k=oDy=_CWMCfcGfy=wbhn0BDm45Y8wS=wpe6SviPcnetntTw@mail.gmail.com>
 <20130718084041.GE11251@arwen.pp.htv.fi> <CA+k=oDxbu09FoQdOVUQhK-Q4hKuPYyiYDS1akoE2kggN7echgA@mail.gmail.com>
 <20130718101058.GG11251@arwen.pp.htv.fi>
From: Barry Song <21cnbao@gmail.com>
Date: Fri, 26 Jul 2013 13:56:19 +0800
Message-ID: <CAGsJ_4w_AU81tiOsCgegFhR6fmC_iDdTMqQP0shddZe4+o+6xw@mail.gmail.com>
Subject: Re: [PATCH] usb: udc: add gadget state kobject uevent
To: balbi@ti.com
Cc: Rong Wang <wr011235813@gmail.com>, Greg KH <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rong.Wang@csr.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/7/18 Felipe Balbi <balbi@ti.com>:
> On Thu, Jul 18, 2013 at 05:28:19PM +0800, Rong Wang wrote:
>> Hi Felipe,
>>
>> Thanks, I'll test the patch.
>>
>> But sysfs_notify(&gadget->dev.kobj, NULL, "status"), status or state ?
>> I notice that DEVICE_ATTR(state, S_IRUGO, usb_gadget_state_show, NULL)
>
> good eyes, please send a patch which I'll queue on this -rc and Cc:
> <stable@vger.kernel.org>.

ok. i will handle that for rong. and pls consider to merge rong's
patch about sending uevent.

>
> I'll rewrite my patch on top of the patched -rc later.
>
> --
> balbi

-barry
