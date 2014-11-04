Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692AbaKDIzW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 03:55:22 -0500
Received: from smtp103.mer-nm.internl.net ([217.149.192.139]:33604 "EHLO
	smtp103.mer-nm.internl.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752511AbaKDIzS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 03:55:18 -0500
X-Spam-Flag: NO
X-Spam-Score: -2.899
X-Spam-Languages: en
Message-ID: <54589472.8030305@topic.nl>
Date: Tue, 4 Nov 2014 09:55:14 +0100
From: Mike Looijmans <mike.looijmans@topic.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: <lgirdwood@gmail.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] Add ltc3562 voltage regulator driver
References: <1414570560-10320-2-git-send-email-mike.looijmans@topic.nl> <1414668415-597-1-git-send-email-mike.looijmans@topic.nl> <20141030165133.GB18557@sirena.org.uk> <54573860.4060708@topic.nl> <20141103120919.GE3815@sirena.org.uk> <545795D8.1040600@topic.nl> <20141103151058.GP3815@sirena.org.uk> <5457BD85.2070901@topic.nl>
In-Reply-To: <5457BD85.2070901@topic.nl>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [192.168.80.45]
X-EXCLAIMER-MD-CONFIG: 9833cda7-5b21-4d34-9a38-8d025ddc3664
X-EXCLAIMER-MD-BIFURCATION-INSTANCE: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

﻿On 11/03/2014 06:38 PM, Mike Looijmans wrote:
> On 3-11-2014 16:10, Mark Brown wrote:
>> On Mon, Nov 03, 2014 at 03:48:56PM +0100, Mike Looijmans wrote:
>>> ﻿On 11/03/2014 01:09 PM, Mark Brown wrote:
>>
>>>> No function calls, just use regulators_node.  What is unclear about the
>>>> functionality?
>>
>>> I don't understand what you mean by "regulators_node".
>>
>>> "grep -R regulators_node *" in the kernel source tree returns no results,
>>> nor does http://lxr.free-electrons.com/ident?i=regulators_node
>>
>> You need to develop against current versions of the kernel, this is
>> something that was merged into Linus' tree during the merge window.
>
> Is this an absolute show-stopper for you?
>
> With some effort I could move from our current 3.15 to 3.17, but even that
> wouldn't be recent enough then. I can justify spending a few days on getting
> the driver integrated into mainline, even if the initial version cost less
> than that; but moving everything to mainline is going to take weeks and the
> boss is definitely going to say "no" to that.

More important than that: Since this chip powers the IO banks, we need it for 
our own products, and hence it has to work (also) on the current 3.15 kernel. 
Using APIs from 3.18 wouold render the driver useless to ourselves.



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

