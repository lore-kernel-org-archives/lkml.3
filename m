Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938AbaANWtT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 17:49:19 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:48425 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416AbaANWtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 17:49:16 -0500
Message-ID: <52D5CCFB.1090205@cogentembedded.com>
Date: Wed, 15 Jan 2014 02:49:15 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: tglx@linutronix.de
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-sh@vger.kernel.org
Subject: Re: [PATCH] irq-gic: remove file name from heading comment
References: <201312140224.53928.sergei.shtylyov@cogentembedded.com>
In-Reply-To: <201312140224.53928.sergei.shtylyov@cogentembedded.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 12/14/2013 02:24 AM, Sergei Shtylyov wrote:

> File names in the heading comments  fell out of favor long ago, and this one
> weren't even changed when the driver was moved from arch/arm/common/, so remove
> it at last...

> Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

> ---
> The patch is against the 'irq/core' branch of the 'tip.git' repo.

    Thomas, is there a chance that you merge this patch for 3.14? Is it even 
the right branch for cleanups (I'm seeing fixes there)?

WBR, Sergei

