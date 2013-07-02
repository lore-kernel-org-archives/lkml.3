Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398Ab3GBRjB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 13:39:01 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:55103 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752910Ab3GBRjA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 13:39:00 -0400
Message-ID: <51D3100C.6010209@ti.com>
Date: Tue, 2 Jul 2013 13:38:20 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Joonsoo Kim <iamjoonsoo.kim@lge.com>, Will Deacon <will.deacon@arm.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Nicolas Pitre <nico@linaro.org>
Subject: Re: [RFC PATCH 5/6] ARM, mm: change meaning of max_low_pfn to maximum
 pfn for nobootmem
References: <1364184674-13798-1-git-send-email-iamjoonsoo.kim@lge.com> <1364184674-13798-6-git-send-email-iamjoonsoo.kim@lge.com> <51D18ED5.50103@ti.com> <20130701170941.GC24642@n2100.arm.linux.org.uk>
In-Reply-To: <20130701170941.GC24642@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 01 July 2013 01:09 PM, Russell King - ARM Linux wrote:
> On Mon, Jul 01, 2013 at 10:14:45AM -0400, Santosh Shilimkar wrote:
>> I have been also carrying similar patch as yours in an attempt
>> to make LPAE kernel work on ARM. Your patch carries better
>> description, so will your version and include in my series
>> which I plan to post on the list after some more testing.
>> Will copy you. The changes are very similar to your series.
> 
> And will you try to investigate and/or address my concerns with this
> change?
> 
Sure. Will try to look and come back to you. 

Regards,
Santosh 

