Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754937Ab3A2JgD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 04:36:03 -0500
Received: from canardo.mork.no ([148.122.252.1]:37584 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752418Ab3A2Jf5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 04:35:57 -0500
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Daniele Palmas <dnlplm@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] NET: qmi_wwan: add Telit LE920 support
Organization: m
References: <1359387918-2791-1-git-send-email-dnlplm@gmail.com>
	<87k3qxnt07.fsf@nemi.mork.no>
	<CAGRyCJEThQaex9au5AbWT-hm1Vvj2jxiXuAfrgNTdTofqAYY3A@mail.gmail.com>
Date: Tue, 29 Jan 2013 10:35:50 +0100
In-Reply-To: <CAGRyCJEThQaex9au5AbWT-hm1Vvj2jxiXuAfrgNTdTofqAYY3A@mail.gmail.com>
	(Daniele Palmas's message of "Tue, 29 Jan 2013 09:40:38 +0100")
Message-ID: <87y5fcz5zd.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniele Palmas <dnlplm@gmail.com> writes:
> 2013/1/28 Bjørn Mork <bjorn@mork.no>:
>
>> Thanks for adding this device. But the patch doesn't apply to the
>> current "net" tree.  Care to rebase it?
>>
>
> Sure. Should I use the following git repository
>
> git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/net-next.git
>
> ?

No, the correct tree to base device additions for drivers/net/usb is

 git://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git

Note that this is different from most other USB devices.

This wouldn't normally be such a big deal, but you were "lucky" and hit
a timeslot when there were unmerged conflicting changes that tree. I am
not trying to be difficult.  It just feels like it :-)

Thanks again for doing this.


Bjørn
