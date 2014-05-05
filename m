Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756612AbaEEL7b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 07:59:31 -0400
Received: from mx02.posteo.de ([89.146.194.165]:34847 "EHLO posteo.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756431AbaEEL73 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 07:59:29 -0400
Message-ID: <53677D1D.5000204@posteo.de>
Date: Mon, 05 May 2014 13:59:25 +0200
From: Martin Kepplinger <martink@posteo.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Icedove/24.4.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: gregkh@linuxfoundation.org, lidza.louina@gmail.com,
        driverdev-devel@linuxdriverproject.org, linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH] staging: dgnc: use dev_err() instead of printk()
References: <1398765250-16064-1-git-send-email-martink@posteo.de> <1399285779-7040-1-git-send-email-martink@posteo.de> <20140505113507.GP26890@mwanda>
In-Reply-To: <20140505113507.GP26890@mwanda>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 2014-05-05 13:35, schrieb Dan Carpenter:
> On Mon, May 05, 2014 at 12:29:39PM +0200, Martin Kepplinger wrote:
>> Use dev_err() instead of printk() and remove "dgnc:" from the message.
>> This should provide userspace with more useful information and use
>> the common kernel coding style.
>>
> 
> Whenever I see a "RESEND" in a subject and no explanation then it means
> our development process has broken down.  Meanwhile this is the first
> time I have seen this patch so the problem is not on our side.
> 
> regards,
> dan carpenter
> 

I just resent https://lkml.org/lkml/2014/4/29/164 after waiting a week
or so. I don't see any breakdown.

                       martin
