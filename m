Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086AbaKCOtG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 09:49:06 -0500
Received: from smtp103.mer-nm.internl.net ([217.149.192.139]:36928 "EHLO
	smtp103.mer-nm.internl.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751852AbaKCOtD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 09:49:03 -0500
X-Spam-Flag: NO
X-Spam-Score: -2.899
X-Spam-Languages: en
Message-ID: <545795D8.1040600@topic.nl>
Date: Mon, 3 Nov 2014 15:48:56 +0100
From: Mike Looijmans <mike.looijmans@topic.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: <lgirdwood@gmail.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] Add ltc3562 voltage regulator driver
References: <1414570560-10320-2-git-send-email-mike.looijmans@topic.nl> <1414668415-597-1-git-send-email-mike.looijmans@topic.nl> <20141030165133.GB18557@sirena.org.uk> <54573860.4060708@topic.nl> <20141103120919.GE3815@sirena.org.uk>
In-Reply-To: <20141103120919.GE3815@sirena.org.uk>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [192.168.80.45]
X-EXCLAIMER-MD-CONFIG: 9833cda7-5b21-4d34-9a38-8d025ddc3664
X-EXCLAIMER-MD-BIFURCATION-INSTANCE: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

﻿On 11/03/2014 01:09 PM, Mark Brown wrote:
> On Mon, Nov 03, 2014 at 09:10:08AM +0100, Mike Looijmans wrote:
>> ﻿On 10/30/2014 05:51 PM, Mark Brown wrote:
>
>>>> +		np_child = of_get_child_by_name(np_regulators,
>>>> +			ltc3562_regulators[i].name);
>>>> +		if (np_child == NULL) {
>
>>> Use the core support for looking up constraints please - set
>>> regulators_node and so on.
>
>> I've been reworking the driver, but this is the only feedback comment I
>> didn't quite understand. What is it that I'm expected to do here? Probably
>> just the name of the method I'm supposed to call here would be enough.
>
> No function calls, just use regulators_node.  What is unclear about the
> functionality?

I don't understand what you mean by "regulators_node".

"grep -R regulators_node *" in the kernel source tree returns no results, nor 
does http://lxr.free-electrons.com/ident?i=regulators_node




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

