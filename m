Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167AbaCOGzG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2014 02:55:06 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:40007 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbaCOGzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2014 02:55:04 -0400
Message-ID: <5323F944.2040400@linux.com>
Date: Sat, 15 Mar 2014 07:55:00 +0100
From: Levente Kurusa <levex@linux.com>
Reply-To: Levente Kurusa <levex@linux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Chase Southwood <chase.southwood@yahoo.com>
CC: Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        OSUOSL Drivers <devel@driverdev.osuosl.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: comedi: fix memory leak
References: <1394813775-12363-1-git-send-email-levex@linux.com> <1394854216.83246.YahooMailNeo@web164002.mail.gq1.yahoo.com>
In-Reply-To: <1394854216.83246.YahooMailNeo@web164002.mail.gq1.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15/2014 04:30 AM, Chase Southwood wrote:
>> On Friday, March 14, 2014 11:47 AM, Levente Kurusa <levex@linux.com> wrote:
> 
>> Call kfree() on bdev. The variable is otherwise leaked.
>>
>> Signed-off-by: Levente Kurusa <levex@linux.com>
>> [...]
>>
> 
> 
> Levente,
> 
> This change has already been made in staging-next (by me, actually :) ).  In
> order to avoid re-doing work which has already been done, please make sure to base
> all of your patches off of linux-next (or for staging, staging-next).
> 
> Thanks,
> Chase
> 

Ah, yes I see now. I wonder how it didn't reach my tree.
Anyways, thanks for the heads up!

-- 
Regards,
Levente Kurusa
