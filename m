Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751301AbaKCIKQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 03:10:16 -0500
Received: from smtp102.mer-nm.internl.net ([217.149.192.138]:46846 "EHLO
	smtp102.mer-nm.internl.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750826AbaKCIKM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 03:10:12 -0500
X-Spam-Flag: NO
X-Spam-Score: -2.899
X-Spam-Languages: en
Message-ID: <54573860.4060708@topic.nl>
Date: Mon, 3 Nov 2014 09:10:08 +0100
From: Mike Looijmans <mike.looijmans@topic.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: <lgirdwood@gmail.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] Add ltc3562 voltage regulator driver
References: <1414570560-10320-2-git-send-email-mike.looijmans@topic.nl> <1414668415-597-1-git-send-email-mike.looijmans@topic.nl> <20141030165133.GB18557@sirena.org.uk>
In-Reply-To: <20141030165133.GB18557@sirena.org.uk>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [192.168.80.45]
X-EXCLAIMER-MD-CONFIG: 9833cda7-5b21-4d34-9a38-8d025ddc3664
X-EXCLAIMER-MD-BIFURCATION-INSTANCE: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

﻿On 10/30/2014 05:51 PM, Mark Brown wrote:
> On Thu, Oct 30, 2014 at 12:26:55PM +0100, Mike Looijmans wrote:
>> +	np = of_node_get(i2c->dev.of_node);
>> +	np_regulators = of_get_child_by_name(np, "regulators");
>
>> +		np_child = of_get_child_by_name(np_regulators,
>> +			ltc3562_regulators[i].name);
>> +		if (np_child == NULL) {
>
> Use the core support for looking up constraints please - set
> regulators_node and so on.

I've been reworking the driver, but this is the only feedback comment I didn't 
quite understand. What is it that I'm expected to do here? Probably just the 
name of the method I'm supposed to call here would be enough.


The rest of your feedback I've processed and tested the results.

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

