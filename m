Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167AbaISLBW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 07:01:22 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755814AbaISLBV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 07:01:21 -0400
Message-ID: <541C0CFE.2090609@nod.at>
Date: Fri, 19 Sep 2014 13:01:18 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: dedekind1@gmail.com
CC: dwmw2@infradead.org, computersforpeace@gmail.com,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] UBI: Fix possible deadlock in erase_worker()
References: <1410853702-11616-1-git-send-email-richard@nod.at>	 <1410946526.28850.120.camel@sauron.fi.intel.com> <541BFB6D.3040903@nod.at> <1411123647.28850.138.camel@sauron.fi.intel.com>
In-Reply-To: <1411123647.28850.138.camel@sauron.fi.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 19.09.2014 12:47, schrieb Artem Bityutskiy:
> On Fri, 2014-09-19 at 11:46 +0200, Richard Weinberg
>> Or we apply "[PATCH 1/2] UBI: Call worker functions without work_sem held". :)
> 
> But I explained in the other e-mail that the semaphore is needed, and
> why.

Sorry, I completely misunderstood your mail.
Rereading it now.

Thanks,
//richard
