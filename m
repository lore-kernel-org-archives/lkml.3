Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083AbaIISrL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 14:47:11 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:58575 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901AbaIISrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 14:47:09 -0400
MIME-Version: 1.0
In-Reply-To: <20140909184318.GA6231@kroah.com>
References: <1410285991-24833-1-git-send-email-ricardo.ribalda@gmail.com> <20140909184318.GA6231@kroah.com>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Tue, 9 Sep 2014 20:46:48 +0200
Message-ID: <CAPybu_3wJ+UPbnkWPFLJdne6Rz8ouUap3E1GeA9NqX=gP4fPug@mail.gmail.com>
Subject: Re: [PATCH 1/3] parisc/uapi: Add definition of TIOC[SG]RS485
To: Greg KH <greg@kroah.com>
Cc: "James E . J . Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-serial@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Greg.

 I have just resend one for sparc. Are we sure that we prefer the
macros instead of using the same value on all arches?

Thanks


On Tue, Sep 9, 2014 at 8:43 PM, Greg KH <greg@kroah.com> wrote:
> On Tue, Sep 09, 2014 at 08:06:31PM +0200, Ricardo Ribalda Delgado wrote:
>> Commit: e676253b19b2d269cccf67fdb1592120a0cd0676 (serial/8250: Add
>> support for RS485 IOCTLs), adds support for RS485 ioctls for 825_core on
>> all the archs. Unfortunaltely the definition of TIOCSRS485 and
>> TIOCGRS485 was missing on the ioctls.h file
>>
>> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
>> ---
>>  arch/parisc/include/uapi/asm/ioctls.h | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/arch/parisc/include/uapi/asm/ioctls.h b/arch/parisc/include/uapi/asm/ioctls.h
>> index 66719c3..3af2d02 100644
>> --- a/arch/parisc/include/uapi/asm/ioctls.h
>> +++ b/arch/parisc/include/uapi/asm/ioctls.h
>> @@ -50,6 +50,8 @@
>>  #define TCSETS2              _IOW('T',0x2B, struct termios2)
>>  #define TCSETSW2     _IOW('T',0x2C, struct termios2)
>>  #define TCSETSF2     _IOW('T',0x2D, struct termios2)
>> +#define TIOCGRS485   0x542E
>> +#define TIOCSRS485   0x542F
>
> As David pointed out with the sparc patch, please use the proper ioctl
> macros for these numbers.
>
> Please redo all of these patches and resend.
>
> thanks,
>
> greg k-h



-- 
Ricardo Ribalda
