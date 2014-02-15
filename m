Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752304AbaBOHxo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 02:53:44 -0500
Received: from mail-ee0-f48.google.com ([74.125.83.48]:51790 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824AbaBOHxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 02:53:42 -0500
Message-ID: <52FF1CFE.40504@linux.com>
Date: Sat, 15 Feb 2014 08:53:34 +0100
From: Levente Kurusa <levex@linux.com>
Reply-To: Levente Kurusa <levex@linux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        OSUOSL Drivers <devel@driverdev.osuosl.org>
Subject: Re: [PATCH] [RFC] staging: rtl8821ae: fix invalid bit mask on MSR_AP
 check
References: <1392414623-4369-1-git-send-email-levex@linux.com> <20140214220041.GD26722@mwanda>
In-Reply-To: <20140214220041.GD26722@mwanda>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14/2014 11:00 PM, Dan Carpenter wrote:
> [...]
>>  Hi,
>>
>>  This might not be the real solution since it is also possible that
>>  the particular condition never really happens. I seek comments
>>  so that I can post the proper patch.
>>
> 
> I can't test it either but I think your fix is correct.
> 
> Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
> [...]

Thanks Dan, maybe you know some people who could test it?
RTLXXXXXX guys? Or maybe we can take the patch as is?
I cannot really think of any other solution other than removing
the other clause, but since that was written to the file,
there must have been some logic behind that. I am slightly
disappointed get_maintainer didn't really find anybody for
this patch...

Greg, can you take it as is or you would need the RFC tag removed?
(ie, repost)
Maybe you know somebody who could test it as well?

-- 
Regards,
Levente Kurusa
