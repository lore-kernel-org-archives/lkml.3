Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759496AbaJ3Lbs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 07:31:48 -0400
Received: from smtp103.mer-nm.internl.net ([217.149.192.139]:46998 "EHLO
	smtp103.mer-nm.internl.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758846AbaJ3Lbq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 07:31:46 -0400
X-Spam-Flag: NO
X-Spam-Score: -2.899
X-Spam-Languages: en
Message-ID: <5452219E.2070802@topic.nl>
Date: Thu, 30 Oct 2014 12:31:42 +0100
From: Mike Looijmans <mike.looijmans@topic.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: <lgirdwood@gmail.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add ltc3562 voltage regulator driver
References: <1414570560-10320-1-git-send-email-mike.looijmans@topic.nl> <1414570560-10320-2-git-send-email-mike.looijmans@topic.nl> <20141029123005.GH18557@sirena.org.uk> <5451DF10.7030605@topic.nl> <20141030101555.GT18557@sirena.org.uk> <5452131F.9000307@topic.nl> <545218B1.8030306@topic.nl> <20141030105848.GU18557@sirena.org.uk>
In-Reply-To: <20141030105848.GU18557@sirena.org.uk>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [192.168.80.45]
X-EXCLAIMER-MD-CONFIG: 9833cda7-5b21-4d34-9a38-8d025ddc3664
X-EXCLAIMER-MD-BIFURCATION-INSTANCE: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

﻿On 10/30/2014 11:58 AM, Mark Brown wrote:
> On Thu, Oct 30, 2014 at 11:53:37AM +0100, Mike Looijmans wrote:
>> ﻿On 10/30/2014 11:29 AM, Mike Looijmans wrote:
>
>>> So I should add "regulator-default-voltage" to the generic code? That would
>>> indeed be better than trying to do it into this driver.
>
>>> But would that need a separate patch for regulator core to add the property?
>
> Yes.
>
>> Hmm, I looked into doing that, but that isn't trivial, and too many devices
>> will suffer.
>
> Why would this have a negative effect on other devices?  Unless somehow
> the other devices add the property they should not be affected by it; if
> users do add the property presumably that's because it's doing something
> useful.

The "default" would end up in the constraints, thus adding extra fields to 
that struct.

So far, all other drivers have accomplished this by setting min=max, and some 
experimenting proved that my driver is no exception to that. It even reduced 
the amount of code.

Mike.



Met vriendelijke groet / kind regards,

Mike Looijmans
System Expert


TOPIC Embedded Systems
Eindhovenseweg 32-C, NL-5683 KH Best
Postbus 440, NL-5680 AK Best
Telefoon: (+31) (0) 499 33 69 79
Telefax:  (+31) (0) 499 33 69 70
E-mail: mike.looijmans@topic.nl
Website: www.topic.nl

Please consider the environment before printing this e-mail

Topic zoekt gedreven (embedded) software specialisten!
http://topic.nl/vacatures/topic-zoekt-software-engineers/

