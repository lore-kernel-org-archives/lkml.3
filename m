Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752244AbaIITkX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 15:40:23 -0400
Received: from mail-oi0-f52.google.com ([209.85.218.52]:33502 "EHLO
	mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590AbaIITkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 15:40:21 -0400
MIME-Version: 1.0
In-Reply-To: <20140909191824.GB7467@kroah.com>
References: <1410240056-22786-1-git-send-email-ricardo.ribalda@gmail.com> <20140909191824.GB7467@kroah.com>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Tue, 9 Sep 2014 21:40:00 +0200
Message-ID: <CAPybu_2Ru64=fL3o7Vs3Fdf+rkREw-faqtRBev3BiXiQEJ_7aw@mail.gmail.com>
Subject: Re: [PATCH 2/2] xtensa/uapi: Add definition of TIOC[SG]RS485
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Chris Zankel <chris@zankel.net>,
        "Max Filippov linux-xtensa @ linux-xtensa . org" <jcmvbkbc@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-serial@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Done

Thanks :)

On Tue, Sep 9, 2014 at 9:18 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Tue, Sep 09, 2014 at 07:20:56AM +0200, Ricardo Ribalda Delgado wrote:
>> Commit: e676253b19b2d269cccf67fdb1592120a0cd0676 [3/21] serial/8250: Add
>> support for RS485 IOCTLs, adds support for RS485 ioctls for 825_core on
>> all the archs. Unfortunaltely the definition of TIOCSRS485 and
>> TIOCGRS485 was missing on the ioctls.h file
>>
>> Reported-by: kbuild test robot <fengguang.wu@intel.com>
>> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
>> ---
>>  arch/xtensa/include/uapi/asm/ioctls.h | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/arch/xtensa/include/uapi/asm/ioctls.h b/arch/xtensa/include/uapi/asm/ioctls.h
>> index a47909f..accda82 100644
>> --- a/arch/xtensa/include/uapi/asm/ioctls.h
>> +++ b/arch/xtensa/include/uapi/asm/ioctls.h
>> @@ -95,6 +95,8 @@
>>  #define TCSETS2              _IOW('T', 43, struct termios2)
>>  #define TCSETSW2     _IOW('T', 44, struct termios2)
>>  #define TCSETSF2     _IOW('T', 45, struct termios2)
>> +#define TIOCGRS485   0x542E
>> +#define TIOCSRS485   0x542F
>
> Like your patches for other arches, please use a _IOW() macro here, not a "number".
>
> thanks,
>
> greg k-h



-- 
Ricardo Ribalda
