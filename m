Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924AbaCKRxm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 13:53:42 -0400
Received: from p3plex2out03.prod.phx3.secureserver.net ([184.168.131.16]:58339
	"EHLO p3plex2out03.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753189AbaCKRxl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 13:53:41 -0400
From: Hartley Sweeten <HartleyS@visionengravers.com>
To: Joe Perches <joe@perches.com>
CC: Fred Akers <knivey@botops.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "abbotti@mev.co.uk" <abbotti@mev.co.uk>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] Staging: comedi: addi-data: Fix long CamelCase
 function names
Thread-Topic: [PATCH v2] Staging: comedi: addi-data: Fix long CamelCase
 function names
Thread-Index: AQHPPU/6/O8B+isg3EKcFid9acWnCZrcJjpggAB46gD//4rs0A==
Date: Tue, 11 Mar 2014 17:53:39 +0000
Message-ID: <DC148C5AA1CEBA4E87973D432B1C2D8825DAD114@P3PWEX4MB008.ex4.secureserver.net>
References: <1394350009-23464-1-git-send-email-knivey@botops.net>
	 <1394559177-14616-1-git-send-email-knivey@botops.net>
	 <DC148C5AA1CEBA4E87973D432B1C2D8825DAD0AF@P3PWEX4MB008.ex4.secureserver.net>
 <1394560152.20021.3.camel@joe-AO722>
In-Reply-To: <1394560152.20021.3.camel@joe-AO722>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [184.183.19.121]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, March 11, 2014 10:49 AM, Joe Perches wrote:
> On Tue, 2014-03-11 at 17:42 +0000, Hartley Sweeten wrote:
>> On Tuesday, March 11, 2014 10:33 AM, Fred Akers wrote:
>>> This patch fixes a few function names that are very long and are
>>> not in the correct naming style
> []
>>> diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c
> []
>>> @@ -111,7 +111,7 @@ static int i_Temp;
>>>  static int i_Flag = 1;
>>>  /*
>>>  +----------------------------------------------------------------------------+
>>> -| Function   Name   : int i_APCI035_ConfigTimerWatchdog                      |
>>> +| Function   Name   : int apci035_timer_config                      |
>>>  |			  (struct comedi_device *dev,struct comedi_subdevice *s,               |
>>>  |                      struct comedi_insn *insn,unsigned int *data)                     |
>>>  +----------------------------------------------------------------------------+
>> 
>> Nitpick... These obvious function comment blocks should be removed.
>> That should be a separate patch. Maybe a patch 1/2 before this one so
>> you don't have to update the comments.
>
> Maybe convert them to kernel-doc style?
>
> /**
>  * foobar() - short function description of foobar
>  * @arg1:	Describe the first argument to foobar.
>  * @arg2:	Describe the second argument to foobar.
>  *		One can provide multiple line descriptions
>  *		for arguments.

For exported functions I agree, but the (dev, s, insn, data) is athe standard
parameter list for most of the comedi subdevice callbacks. I don't think
these need any comments.

Regards,
Hartley

