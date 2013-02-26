Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759604Ab3BZXiu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 18:38:50 -0500
Received: from casper.infradead.org ([85.118.1.10]:42705 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759240Ab3BZXip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:38:45 -0500
Message-ID: <512D47AB.9030401@infradead.org>
Date: Tue, 26 Feb 2013 15:39:23 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Nishanth Menon <nm@ti.com>
CC: linux-pm <linux-pm@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PM / OPP: improve introductory documentation
References: <1361900231-10478-1-git-send-email-nm@ti.com> <512D3A9C.5040801@infradead.org> <20130226231038.GB24732@kahuna>
In-Reply-To: <20130226231038.GB24732@kahuna>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26/13 15:10, Nishanth Menon wrote:
> On 14:43-20130226, Randy Dunlap wrote:
>> On 02/26/13 09:37, Nishanth Menon wrote:
> [..]
>>>  
>>>  1. Introduction
>>>  ===============
>>> +1.1 What is an Operating Performance Point (OPP)?
>>> +
>>>  Complex SoCs of today consists of a multiple sub-modules working in conjunction.
>>>  In an operational system executing varied use cases, not all modules in the SoC
>>>  need to function at their highest performing frequency all the time. To
>>>  facilitate this, sub-modules in a SoC are grouped into domains, allowing some
>>>  domains to run at lower voltage and frequency while other domains are loaded
>>> -more. The set of discrete tuples consisting of frequency and voltage pairs that
>>> +more.
>>
>> huh???
> I split the definition line to it's own paragraph below. But, I think
> you intend to say we could improve better the remaining paragraph.
> Could you elaborate your thoughts?

"while other domains are loaded more."  Some people probably understand
that OK; I dunno.  I would rather see it written out more verbosely, e.g.:

"while other domains run at voltage/frequency pairs that are higher."

but partly I was confused by the diff(1) lines.  my bad :(


>>> +
>>> +The set of discrete tuples consisting of frequency and voltage pairs that
>>>  the device will support per domain are called Operating Performance Points or
>>>  OPPs.
>>>  
>>> +As an example:
>>> +Let us consider an MPU device which supports the following:
>>> +{300MHz at minimum voltage of 1V}, {800MHz at minimum voltage of 1.2V},
>>> +{1GHz at minimum voltage of 1.3V}
>>> +
>>> +We can represent these as three OPPs as the following {Hz, uV} tuples:
>>> +{300000000, 1000000}
>>> +{600000000, 1200000}
>>     800000000
>>
>>> +{100000000, 1300000}
>>     1000000000 ??
> Thanks for catching it. will fix it in next rev.
> 


-- 
~Randy
