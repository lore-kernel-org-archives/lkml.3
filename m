Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462Ab3GIAKK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 20:10:10 -0400
Received: from us-mx1.synaptics.com ([12.239.216.75]:14202 "EHLO
	us-mx1.synaptics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753400Ab3GIAKH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 20:10:07 -0400
X-PGP-Universal: processed;
	by securemail.synaptics.com on Mon, 08 Jul 2013 17:10:07 -0700
From: Christopher Heiny <Cheiny@synaptics.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Balint Czobor <czoborbalint@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/1] drivers: input: touchscreen: Initial support for
 SYNAPTICS_I2C_RMI touchscreen
Thread-Topic: [PATCH 1/1] drivers: input: touchscreen: Initial support for
 SYNAPTICS_I2C_RMI touchscreen
Thread-Index: AQHOe7Us/ZfYw/7hlkST96adq2j1hJlbWyuAgAAANPWAAHpyAP//o+E9
Date: Tue, 9 Jul 2013 00:09:38 +0000
Message-ID: <BFABBC009FBA1C43B207B15FD485ABD92FDEC0F2@usw-mail3.synaptics-inc.local>
References: <1373271947-8393-1-git-send-email-czoborbalint@gmail.com>
 <51DB3B13.7070805@synaptics.com>
 <BFABBC009FBA1C43B207B15FD485ABD92FDEB5DC@usw-mail3.synaptics-inc.local>,<3502283.ihV8RhfYF2@dtor-d630.eng.vmware.com>
In-Reply-To: <3502283.ihV8RhfYF2@dtor-d630.eng.vmware.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.3.20.75]
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry if this is a duplicate - there's some email issues here at work.

On 07/08/2013 03:39 PM, Dmitry Torokhov wrote:
> On Monday, July 08, 2013 10:21:16 PM Christopher Heiny wrote:
>> On 07/08/2013 01:25 AM, Balint Czobor wrote:
>>> Add initial support for Synaptics RMI over I2C based touchscreens.
>>
>> This is pretty old code - it looks like a modification of patches we
>> submitted last year.  Is there some reason you're not basing it off the
>> latest checkins in synaptics-rmi4 branch of  Dmitry's input tree?
>
> That branch is fairly old as well, I believe you have much never
> version on Github?

Yes, I do, but I figured your branch was the reference.

Balint - there newest code is here:

    https://github.com/mightybigcar/synaptics-rmi4

There are two branches.  The main branch tracks work intended for the
next submission.    The development branch is a superset of that work,
including all currently supported and in development RMI4 function
implementations.

If you would like to integrate that work into your kernel, I'll be happy
to help out with that (and I suspect Dmitry and others would be too).

					Thanks,
						Chris

