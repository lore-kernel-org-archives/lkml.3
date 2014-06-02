Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366AbaFBTXV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 15:23:21 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:61552 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285AbaFBTXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 15:23:19 -0400
Message-ID: <538CCF24.1030800@gmail.com>
Date: Mon, 02 Jun 2014 12:23:16 -0700
From: Thomas Wood <tommyandrena@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: marek.belisko@gmail.com, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: ft1000: ft1000-usb: ft1000_debug.c: Fix style
 errors and some warnings.
References: <1401675978-25765-1-git-send-email-tommyandrena@gmail.com> <20140602103056.GY15585@mwanda>
In-Reply-To: <20140602103056.GY15585@mwanda>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 06/02/2014 03:30 AM, Dan Carpenter wrote:
> On Sun, Jun 01, 2014 at 07:26:18PM -0700, Thomas Wood wrote:
>> Don't use spaces as tabs, and fix other style errors and warnings.
>>
>> Signed-off-by: Thomas Wood <tommyandrena@gmail.com>
> 
> Too much in one patch.  Break it up into one type of fix per patch and
> send a series of patches.
> 
> [patch 1] use tabs
> [patch 2] fix braces style
> [patch 3] remove parens from return values
> [patch 4] reverse an if statement
> 
> patch 3 and 4 are small enough that you could get away with pushing them
> into a single "misc fixes" patch and we wouldn't have complained but the
> first two patches are very big.
> 
> regards,
> dan carpenter
> 
> 
Ah, thank you. I will do so.
