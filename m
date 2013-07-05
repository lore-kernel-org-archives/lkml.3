Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932890Ab3GENto (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 09:49:44 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:45831 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170Ab3GENtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 09:49:42 -0400
From: Peter Korsgaard <jacmet@sunsite.dk>
To: "Joseph Chang" <joseph_chang@davicom.com.tw>
Cc: "'Joseph CHANG'" <josright123@gmail.com>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <netdev@vger.kernel.org>, <josright@hotmail.com>
Subject: Re: [PATCH 1/1] net: add dm9620 net usb driver
References: <201307030548.r635mxI6027578@mail.davicom.com.tw>
Date: Fri, 05 Jul 2013 15:49:36 +0200
In-Reply-To: <201307030548.r635mxI6027578@mail.davicom.com.tw> (Joseph Chang's
	message of "Wed, 3 Jul 2013 13:49:11 +0800")
Message-ID: <87bo6hjevj.fsf@dell.be.48ers.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Joseph" == Joseph Chang <joseph_chang@davicom.com.tw> writes:

Hi,

 Joseph>   This is Joseph CHANG, I am glade to contact and work with
 Joseph>   you.  I am busy in some affairs else these days, and will
 Joseph>   like to be back soon.

 Joseph>   For the begin, We copy the source code 'dm9601.c' which was
 Joseph>   by you, In order to work for our new chips (DM9620, DM9621,
 Joseph>   DM9621A... series), We did modify to get 'dm9620.c' base on
 Joseph>   'dm0601.c', Since you are the author and also the owner, so
 Joseph>   keep MODULE_AUTHOR() as you.

Yes, that's what I learned from a number of bug reports. It would have
been good if you would have worked with me to get your modifications
integrated instead.


 Joseph>   To generate DM9620.c is a way to distinguish the different
 Joseph>   generation chips: (as below)

 Joseph>    DM9601: old revision:     USB1.1, Ethernet 10/100,     Phase out
 Joseph>    DM9620: current revision:  USB2.0, Ethernet 10/100, Mass production state
 Joseph>    DM9633: next revision: USB3.0, Ethernet 10/100/1000, Will to
 Joseph> release on 2013/E

dm9620 is basically backwards compatible with dm9601, so I added dm9620
support to the dm9601 driver earlier this year:

https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=6642f91c92da0736

Is there anything missing from that?

I don't see any dm9633 datasheet on the davicom website, so I cannot say
if it makes sense to add support for it in the existing driver. Is the
datasheet available somewhere?


 Joseph>   So want to make it from the configuration by "make
 Joseph>   menuconfig".

 Joseph>   Can you help give further advices, we hope you can go ahead
 Joseph> be the owner (author) of the 'dm9620.c', And then we make patch
 Joseph> to it. Would you agree this idea? If so we will be happy
 Joseph> because we did not ever create such a code.

 Joseph>   * Think about DM9633 driver to be, It will be is total
 Joseph> different compare to DM9601 & DM9620. And will get the same
 Joseph> issue.

If you can provide me with a dm9633 datasheet and a sample device then I
can look into writing a driver for it / extending dm9601.c. Please
contact me off list for that.

Thanks!

-- 
Bye, Peter Korsgaard
