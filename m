Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753165AbaKDKza (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 05:55:30 -0500
Received: from outbound-smtp04.blacknight.com ([81.17.249.35]:58309 "EHLO
	outbound-smtp04.blacknight.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751017AbaKDKyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 05:54:32 -0500
Message-ID: <5458B066.1010803@nexus-software.ie>
Date: Tue, 04 Nov 2014 10:54:30 +0000
From: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: "Chen, Alvin" <alvin.chen@intel.com>,
        "Tan, Raymond" <raymond.tan@intel.com>,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Shevchenko, Andriy" <andriy.shevchenko@intel.com>
Subject: Re: [PATCH 1/1] mfd: intel_quark_i2c_gpio: Add Intel Quark X1000
 I2C-GPIO MFD Driver
References: <1415000344-23575-1-git-send-email-raymond.tan@intel.com> <1415000344-23575-2-git-send-email-raymond.tan@intel.com> <54575A68.7060009@nexus-software.ie> <4656BEB6164FC34F8171C6538F1A595B2E9AB082@SHSMSX101.ccr.corp.intel.com>
In-Reply-To: <4656BEB6164FC34F8171C6538F1A595B2E9AB082@SHSMSX101.ccr.corp.intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/14 00:51, Chen, Alvin wrote:
>> -----Original Message-----
>> From: Chen, Alvin
>> Sent: Tuesday, November 4, 2014 8:46 AM
>> To: 'Bryan O'Donoghue'; Tan, Raymond; Lee Jones; Samuel Ortiz
>> Cc: linux-kernel@vger.kernel.org; Shevchenko, Andriy
>> Subject: RE: [PATCH 1/1] mfd: intel_quark_i2c_gpio: Add Intel Quark X1000
>> I2C-GPIO MFD Driver
>>
>>>
>>> On 03/11/14 07:39, Raymond Tan wrote:
>>>> +	pdata->properties->irq	= pdev->irq;
>>>> +	pdata->properties->irq_shared	= true;
>>>
>>> OK I see it.
>>>
>>> Thanks.
>>>
>>> My question is. How extensively have edge triggered interrupts been
>>> tested on the GPIO block ?
>>>
>>> The BSP reference code is quite explicit about not missing edge interrupts.
>>>
>>> Have you tested GPIO input in edge mode ?
>> We indeed test edge mode. Now all are moved to gpio-dwapb module which
>> has been accepted by maintainer.

OK then good enough for me.
