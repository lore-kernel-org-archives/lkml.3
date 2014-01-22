Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647AbaAVWKb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 17:10:31 -0500
Received: from mail1.windriver.com ([147.11.146.13]:58069 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527AbaAVWKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 17:10:30 -0500
Message-ID: <52E041E7.4010908@windriver.com>
Date: Wed, 22 Jan 2014 17:10:47 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@linux.intel.com>,
        David Cohen <david.a.cohen@linux.intel.com>
CC: <linux-kernel@vger.kernel.org>, <x86@kernel.org>, <fengguang.wu@intel.com>,
        Kuppuswamy Sathyanarayanan 
	<sathyanarayanan.kuppuswamy@linux.intel.com>,
        Fei Yang <fei.yang@intel.com>
Subject: Re: [PATCH v2] x86: don't introduce more __cpuinit users in intel_mid_weak_decls.h
References: <52dff2dd.pH9hExjpyBbWvw0a%fengguang.wu@intel.com> <1390412055-19341-1-git-send-email-paul.gortmaker@windriver.com> <20140122215032.GA6519@psi-dev26.jf.intel.com> <52E0404E.4010403@linux.intel.com>
In-Reply-To: <52E0404E.4010403@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14-01-22 05:03 PM, H. Peter Anvin wrote:
> On 01/22/2014 01:50 PM, David Cohen wrote:
>>>  
>>> -void * __cpuinit get_penwell_ops()
>>> +void *get_penwell_ops()
>>>  {
>>>  	return &penwell_ops;
>>>  }
>>>  
>>> -void * __cpuinit get_cloverview_ops()
>>> +void *get_cloverview_ops()
>>>  {
>>>  	return &penwell_ops;
>>>  }
>>
> 
> Can someone also find and fix the missing (void)s?

Sure, I can do that, if nobody else wants to.

P.
--

> 
> 	-hpa
> 
> 
