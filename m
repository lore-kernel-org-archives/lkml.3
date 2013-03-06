Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752371Ab3CFBji (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 20:39:38 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:58001 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750767Ab3CFBjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 20:39:36 -0500
X-Sasl-enc: k80+Vmtarz306qUxdQ8zt9TGetMqF26xAR1onSpKpiaE 1362533975
Date: Wed, 6 Mar 2013 09:40:01 +0800
From: "greg@kroah.com" <greg@kroah.com>
To: =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc: "Fangxiaozhi (Franko)" <fangxiaozhi@huawei.com>,
        Oliver Neukum <oneukum@suse.de>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Xueguiying (Zihan)" <zihan.xue@huawei.com>,
        "Linlei (Lei Lin)" <lei.lin@huawei.com>,
        "Yili (Neil)" <neil.yi@huawei.com>,
        "Wangyuhua (Roger, Credit)" <wangyuhua@huawei.com>,
        "Huqiao (C)" <huqiao36@huawei.com>, "balbi@ti.com" <balbi@ti.com>,
        "mdharm-usb@one-eyed-alien.net" <mdharm-usb@one-eyed-alien.net>,
        "sebastian@breakpoint.cc" <sebastian@breakpoint.cc>
Subject: Re: v3.8 regression: Huawei mode switching fails (was Re: [PATCH
 2/2]linux-usb:optimize to match the Huawei USB storage devices and support
 new switch command)
Message-ID: <20130306014001.GD8260@kroah.com>
References: <fe8c966212fb.12fbfe8c9662@huawei.com>
 <87obezs888.fsf@nemi.mork.no>
 <910F9D9E13B84F4C8FA771DC9BDE99F327098368@szxeml546-mbx.china.huawei.com>
 <3774811.9hgnDZEBaM@linux-5eaq.site>
 <910F9D9E13B84F4C8FA771DC9BDE99F32709994F@szxeml546-mbx.china.huawei.com>
 <87lia2ox16.fsf@nemi.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87lia2ox16.fsf@nemi.mork.no>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 05, 2013 at 01:23:33PM +0100, Bjørn Mork wrote:
> As you are well aware of, we parse descriptors as needed on Linux and
> can just as easy support the Windows look'n'feel if required.  There is
> absolutely no need to create special Linux descriptors to adapt to
> existing drivers.  We'll rather fix the drivers than using a mode which
> isn't tested by the Windows users.

I totally agree with this, and this is the way the rest of Linux works.
There should not be any difference in the hardware descriptors between
operating systems.

If Linux isn't working properly for some hardware, we will fix it, do
not work around Linux issues (perceived or real) in hardware.

Bjørn, thanks for catching this kernel change, I'll revert it and push
the changes to the stable kernel releases.  It was my fault to not
notice this bug, my apologies.

greg k-h
