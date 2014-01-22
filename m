Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598AbaAVWEC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 17:04:02 -0500
Received: from mga09.intel.com ([134.134.136.24]:62192 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753049AbaAVWEA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 17:04:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,702,1384329600"; 
   d="scan'208";a="470952963"
Message-ID: <52E0404E.4010403@linux.intel.com>
Date: Wed, 22 Jan 2014 14:03:58 -0800
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: David Cohen <david.a.cohen@linux.intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
CC: linux-kernel@vger.kernel.org, x86@kernel.org, fengguang.wu@intel.com,
        Kuppuswamy Sathyanarayanan 
	<sathyanarayanan.kuppuswamy@linux.intel.com>,
        Fei Yang <fei.yang@intel.com>
Subject: Re: [PATCH v2] x86: don't introduce more __cpuinit users in intel_mid_weak_decls.h
References: <52dff2dd.pH9hExjpyBbWvw0a%fengguang.wu@intel.com> <1390412055-19341-1-git-send-email-paul.gortmaker@windriver.com> <20140122215032.GA6519@psi-dev26.jf.intel.com>
In-Reply-To: <20140122215032.GA6519@psi-dev26.jf.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2014 01:50 PM, David Cohen wrote:
>>  
>> -void * __cpuinit get_penwell_ops()
>> +void *get_penwell_ops()
>>  {
>>  	return &penwell_ops;
>>  }
>>  
>> -void * __cpuinit get_cloverview_ops()
>> +void *get_cloverview_ops()
>>  {
>>  	return &penwell_ops;
>>  }
> 

Can someone also find and fix the missing (void)s?

	-hpa


