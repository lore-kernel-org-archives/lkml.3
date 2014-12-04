Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752423AbaLDCd3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 21:33:29 -0500
Received: from lists.s-osg.org ([54.187.51.154]:39186 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751896AbaLDCd1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 21:33:27 -0500
Message-ID: <547FC7F5.10804@osg.samsung.com>
Date: Wed, 03 Dec 2014 19:33:25 -0700
From: Shuah Khan <shuahkh@osg.samsung.com>
Organization: Samsung Open Source Group
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Josh Triplett <josh@joshtriplett.org>, Tim Bird <tim.bird@sonymobile.com>
CC: "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "linux-embedded@vger.kernel.org" <linux-embedded@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: [PATCH v6] selftest: size: Add size test for Linux kernel
References: <547F598D.7030205@sonymobile.com> <20141204003653.GA5004@thin> <547FAFC3.40609@osg.samsung.com>
In-Reply-To: <547FAFC3.40609@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2014 05:50 PM, Shuah Khan wrote:
> On 12/03/2014 05:36 PM, Josh Triplett wrote:
>> On Wed, Dec 03, 2014 at 10:42:21AM -0800, Tim Bird wrote:
>>> This test shows the amount of memory used by the system.
>>> Note that this is dependent on the user-space that is loaded
>>> when this program runs.  Optimally, this program would be
>>> run as the init program itself.
>>>
>>> The program is optimized for size itself, to avoid conflating
>>> its own execution with that of the system software.
>>> The code is compiled statically, with no stdlibs. On my x86_64 system,
>>> this results in a statically linked binary of less than 5K.
>>>
>>> Signed-off-by: Tim Bird <tim.bird@sonymobile.com>
>>
>> v6 looks good to me.
>>
>> Reviewed-by: Josh Triplett <josh@joshtriplett.org>
>>
>> Should this go through the tinification tree or the selftests tree?
>>
> 
> Josh/Tim,
> 
> Thanks both. Yes v6 looks good. I will take this through kselftest
> tree. I will apply this to kselftes fixes.
> 

Applied to kselftest fixes branch.

-- Shuah


-- 
Shuah Khan
Sr. Linux Kernel Developer
Samsung Open Source Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
