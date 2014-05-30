Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755031AbaE3GX2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 02:23:28 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:46330 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412AbaE3GX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 02:23:26 -0400
MIME-Version: 1.0
In-Reply-To: <1401372183.25908.3.camel@x220>
References: <20140529131650.2329.3197.sendpatchset@w520>
	<20140529131732.2329.50630.sendpatchset@w520>
	<20140529132034.GB15585@mwanda>
	<CANqRtoTzOn5d9qB85sXvmLYhoTDMDtbjSkLbz9V4FRmzFM3ycQ@mail.gmail.com>
	<CANqRtoQDQLsWOyRSbQmtbmJc_qO=5X3ZMK12ZuwZ-FSR1iWCog@mail.gmail.com>
	<1401372183.25908.3.camel@x220>
Date: Fri, 30 May 2014 15:23:25 +0900
Message-ID: <CANqRtoThLHgsbU-zbmpAtYq+mYuD126Shm3ZiVdZzm84XD2WZg@mail.gmail.com>
Subject: Re: [PATCH v2 04/05] staging: board: Initial board staging support
From: Magnus Damm <magnus.damm@gmail.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        devel <devel@driverdev.osuosl.org>,
        SH-Linux <linux-sh@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        "Simon Horman [Horms]" <horms@verge.net.au>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Olof Johansson <olof@lixom.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 11:03 PM, Paul Bolle <pebolle@tiscali.nl> wrote:
> On Thu, 2014-05-29 at 22:53 +0900, Magnus Damm wrote:
>> --- 0011/drivers/staging/board/Kconfig
>> +++ work/drivers/staging/board/Kconfig    2014-05-29 22:32:39.000000000 +0900
>> @@ -1,5 +1,6 @@
>>  config STAGING_BOARD
>>      boolean "Staging Board Support"
>> +    depends on OF && OF_ADDRESS
>
> I have no idea what this is all about, but wouldn't just OF_ADDRESS be
> enough here (as OF_ADDRESS depends on OF)?

Yeah, that makes sense. I am also considering stubbing in the missing
function prototypes in the header files to be able to get rid of this
dependency.

Cheers,

/ magnus
