Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933586AbaFCUuU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 16:50:20 -0400
Received: from mga11.intel.com ([192.55.52.93]:16464 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752458AbaFCUuS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 16:50:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,968,1392192000"; 
   d="scan'208";a="541977831"
Message-ID: <538E3472.2050304@intel.com>
Date: Tue, 03 Jun 2014 13:47:46 -0700
From: Tadeusz Struk <tadeusz.struk@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@infradead.org>, herbert@gondor.apana.org.au
CC: john.griffin@intel.com, bruce.w.allan@intel.com, karen.xiang@intel.com,
        pingchaox.yang@intel.com, bo.cui@intel.com, davem@davemloft.net,
        qat-linux@intel.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, dwmw2@infradead.org, ben@decadent.org.uk
Subject: Re: [RFC][PATCH 4/4] crypto: Updated makefiles to add QAT
References: <20140603182400.GA18752@gitlad.jf.intel.com> <538E1F06.8070300@infradead.org>
In-Reply-To: <538E1F06.8070300@infradead.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/2014 12:16 PM, Randy Dunlap wrote:
>> +source "drivers/crypto/qat/Kconfig"
> Missing that file ^^^^^^^^^^^^^^^^^^^
>

Hi,
Something went wrong. I need to resend v2.
Thanks Randy

