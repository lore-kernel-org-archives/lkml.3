Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755107AbaCDXKQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 18:10:16 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:58445 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625AbaCDXKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 18:10:13 -0500
Message-ID: <53166B67.2060804@cogentembedded.com>
Date: Wed, 05 Mar 2014 03:10:15 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: tglx@linutronix.de
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-sh@vger.kernel.org
Subject: Re: [PATCH] irq-gic: remove file name from heading comment
References: <201312140224.53928.sergei.shtylyov@cogentembedded.com> <52D5CCFB.1090205@cogentembedded.com>
In-Reply-To: <52D5CCFB.1090205@cogentembedded.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 01/15/2014 02:49 AM, Sergei Shtylyov wrote:

>> File names in the heading comments  fell out of favor long ago, and this one
>> weren't even changed when the driver was moved from arch/arm/common/, so remove
>> it at last...

>> Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

>> ---
>> The patch is against the 'irq/core' branch of the 'tip.git' repo.

>     Thomas, is there a chance that you merge this patch for 3.14? Is it even
> the right branch for cleanups (I'm seeing fixes there)?

    Thomas, will you ever reply to me? Who's maintaining the GIC driver, you?
Or the patches shoud just go in via arm-soc.git?

WBR, Sergei

