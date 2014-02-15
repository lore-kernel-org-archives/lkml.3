Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793AbaBOK4m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 05:56:42 -0500
Received: from mail-ea0-f175.google.com ([209.85.215.175]:42592 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628AbaBOK4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 05:56:41 -0500
Message-ID: <52FF47E1.3060507@linux.com>
Date: Sat, 15 Feb 2014 11:56:33 +0100
From: Levente Kurusa <levex@linux.com>
Reply-To: Levente Kurusa <levex@linux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        OSUOSL Drivers <devel@driverdev.osuosl.org>
Subject: Re: [PATCH] [RFC] staging: rtl8821ae: fix invalid bit mask on MSR_AP
 check
References: <1392414623-4369-1-git-send-email-levex@linux.com> <20140214220041.GD26722@mwanda> <52FF1CFE.40504@linux.com> <20140215103623.GE26722@mwanda>
In-Reply-To: <20140215103623.GE26722@mwanda>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/15/2014 11:36 AM, Dan Carpenter wrote:
> On Sat, Feb 15, 2014 at 08:53:34AM +0100, Levente Kurusa wrote:
>> Thanks Dan, maybe you know some people who could test it?
>> RTLXXXXXX guys? Or maybe we can take the patch as is?
>> I cannot really think of any other solution other than removing
>> the other clause, but since that was written to the file,
>> there must have been some logic behind that. I am slightly
>> disappointed get_maintainer didn't really find anybody for
>> this patch...
> 
> This driver is going to be deleted in the next couple weeks and replaced
> with a re-written from scratch driver.
> 

Oh, I did not know that. Since this fix isn't that big, I think it won't
get into the next -rc, and hence might not hit Linus' tree before
the new driver gets into staging. I am not sure if it is worth applying
if that is the case.

-- 
Regards,
Levente Kurusa
