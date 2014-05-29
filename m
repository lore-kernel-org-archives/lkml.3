Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932691AbaE2N1d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 09:27:33 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:49292 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757370AbaE2N1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 09:27:32 -0400
MIME-Version: 1.0
In-Reply-To: <20140529132034.GB15585@mwanda>
References: <20140529131650.2329.3197.sendpatchset@w520>
	<20140529131732.2329.50630.sendpatchset@w520>
	<20140529132034.GB15585@mwanda>
Date: Thu, 29 May 2014 22:27:30 +0900
Message-ID: <CANqRtoTzOn5d9qB85sXvmLYhoTDMDtbjSkLbz9V4FRmzFM3ycQ@mail.gmail.com>
Subject: Re: [PATCH v2 04/05] staging: board: Initial board staging support
From: Magnus Damm <magnus.damm@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
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

Hi Dan,

On Thu, May 29, 2014 at 10:20 PM, Dan Carpenter
<dan.carpenter@oracle.com> wrote:
> On Thu, May 29, 2014 at 10:17:32PM +0900, Magnus Damm wrote:
>> --- /dev/null
>> +++ work/drivers/staging/board/Kconfig        2014-05-29 21:40:41.000000000 +0900
>> @@ -0,0 +1,7 @@
>> +config STAGING_BOARD
>> +     boolean "Staging Board Support"
>> +     help
>> +       Select to enable per-board staging support code.
>> +
>> +       If in doubt, say N here.
>> +
>
> Actually, you're probably going to need to add a bunch of dependencies
> here or it will break "make randconfig" right away.  Sorry that I forgot
> about this in the first review.

Good point, thanks for checking. I will have a look at this and add
dependencies to make sure it builds on a wide range of platforms.

Regarding the emxx_udc portion of the patches (in the v2 series patch
1 -> 3), if there are no objections would it be possible for you to
take them as-is? If so I'll resend the staging board bits only.

Thanks!

/ magnus
