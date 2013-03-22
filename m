Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722Ab3CVSjS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 14:39:18 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:55595 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754565Ab3CVSjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 14:39:17 -0400
Message-ID: <514CA544.5080006@ti.com>
Date: Fri, 22 Mar 2013 13:39:00 -0500
From: Jon Hunter <jon-hunter@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>,
        <linux-omap@vger.kernel.org>, <tony@atomide.com>, <khilman@ti.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mach_omap2: use PTR_RET instead of IS_ERR + PTR_ERR
References: <1363075109-27038-1-git-send-email-silviupopescu1990@gmail.com> <20130312110557.GF30923@n2100.arm.linux.org.uk> <5149FFDF.6050501@ti.com> <20130322163650.GN30923@n2100.arm.linux.org.uk>
In-Reply-To: <20130322163650.GN30923@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.24.115.187]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 03/22/2013 11:36 AM, Russell King - ARM Linux wrote:
> On Wed, Mar 20, 2013 at 01:28:47PM -0500, Jon Hunter wrote:
>> Sorry I am now not sure I follow you here. Someone just pointed out to
>> me that PTR_RET() is defined as ...
>>
>> static inline int __must_check PTR_RET(const void *ptr)
>> {
>> 	if (IS_ERR(ptr))
>> 		return PTR_ERR(ptr);
>> 	else
>> 		return 0;
>> }
>>
>> So the above change appears to be equivalent. Is there something that is
>> wrong with the current implementation that needs to be fixed?
> 
> No - I misread it as PTR_ERR not PTR_RET.  Your patch is fine.

Thanks for confirming. I had made the same mistake recently too!

Jon

