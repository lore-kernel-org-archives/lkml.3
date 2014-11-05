Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559AbaKELp4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 06:45:56 -0500
Received: from smtp103.mer-nm.internl.net ([217.149.192.139]:48686 "EHLO
	smtp103.mer-nm.internl.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753644AbaKELpz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 06:45:55 -0500
X-Spam-Flag: NO
X-Spam-Score: -2.899
X-Spam-Languages: en
Message-ID: <545A0DF0.9030504@topic.nl>
Date: Wed, 5 Nov 2014 12:45:52 +0100
From: Mike Looijmans <mike.looijmans@topic.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: <lgirdwood@gmail.com>, <linux-kernel@vger.kernel.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: Re: [PATCH v2] Add ltc3562 voltage regulator driver
References: <1414668415-597-1-git-send-email-mike.looijmans@topic.nl> <20141030165133.GB18557@sirena.org.uk> <54573860.4060708@topic.nl> <20141103120919.GE3815@sirena.org.uk> <545795D8.1040600@topic.nl> <20141103151058.GP3815@sirena.org.uk> <5457BD85.2070901@topic.nl> <54589472.8030305@topic.nl> <20141104113417.GG3815@sirena.org.uk> <5458D636.3000401@topic.nl> <20141104194729.GV3815@sirena.org.uk>
In-Reply-To: <20141104194729.GV3815@sirena.org.uk>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [192.168.80.45]
X-EXCLAIMER-MD-CONFIG: 9833cda7-5b21-4d34-9a38-8d025ddc3664
X-EXCLAIMER-MD-BIFURCATION-INSTANCE: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

﻿On 11/04/2014 08:47 PM, Mark Brown wrote:
> On Tue, Nov 04, 2014 at 02:35:50PM +0100, Mike Looijmans wrote:
>
>> I still need help with one thing that isn't clear to me though. The DT is
>> parsed when calling regulator_register. But then how do I fetch my "private"
>> settings in there BEFORE the regulator gets enabled? The feedback resistors
>> and regulator mode must be set to the correct board before the output is
>> enabled, otherwise it may damage the chip and its periferals.
>
> Add a callback for this.  Javier and/or Krzysztof were looking at this
> for some other stuff, though I think they were intending to add core
> functionality for their specific feature.
>

I've run out of my hours-to-spend-on-driver-submission budget for this period 
, so it'll be at least a week before I can post a new version. The good news 
is that I have upgrading the kernel to 3.17 on the planning board now, so 
that'll at least reduce the version gap.

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

