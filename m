Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757723Ab3CDQrn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 11:47:43 -0500
Received: from canardo.mork.no ([148.122.252.1]:47452 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756765Ab3CDQrk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 11:47:40 -0500
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        fangxiaozhi@huawei.com, zihan@huawei.com, Lin.Lei@huawei.com,
        Greg KH <gregkh@linuxfoundation.org>, neil.yi@huawei.com,
        wangyuhua@huawei.com, huqiao36@huawei.com, balbi@ti.com,
        mdharm-usb@one-eyed-alien.net, sebastian@breakpoint.cc,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] USB: storage: fix Huawei mode switching regression
Organization: m
References: <87obezs888.fsf@nemi.mork.no>
	<1362403161-23501-1-git-send-email-bjorn@mork.no>
	<1362407359.3768.337.camel@deadeye.wl.decadent.org.uk>
Date: Mon, 04 Mar 2013 17:47:01 +0100
In-Reply-To: <1362407359.3768.337.camel@deadeye.wl.decadent.org.uk> (Ben
	Hutchings's message of "Mon, 04 Mar 2013 14:29:19 +0000")
Message-ID: <878v63ru2i.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Hutchings <ben@decadent.org.uk> writes:
> On Mon, 2013-03-04 at 14:19 +0100, Bjørn Mork wrote:
> [...]
>> In-kernel mode switching was deprecated years ago with the
>> development of the more user friendly userspace alternatives. The
>> existing list of devices in usb-storage was only kept to prevent
>> breaking already working systems.  The long term plan is to remove
>> the list, not to add to it. Ref:
>> http://permalink.gmane.org/gmane.linux.usb.general/28543
> [...]
>
> Can you add a comment to this effect?

In the table in unusual_devs.h, you mean?  Sure, I can do that.

But it feels a bit strange since I can only quote and/or refer to what
Matthew and Greg said about the issue years ago.  Putting a comment in
the code to remind the current maintainers about their own statements
could be considered out of line?  Or is this appropriate here?


Bjørn
