Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755318AbaCRLSv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 07:18:51 -0400
Received: from dehamd003.servertools24.de ([31.47.254.18]:42690 "EHLO
	dehamd003.servertools24.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755206AbaCRLSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 07:18:49 -0400
X-Greylist: delayed 505 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Mar 2014 07:18:49 EDT
X-No-Relay: not in my network
X-No-Relay: not in my network
Message-ID: <5328299C.10807@ladisch.de>
Date: Tue, 18 Mar 2014 12:10:20 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: noman pouigt <variksla@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: atomic read and increment question
References: <CAES_P+-FDQKQSSSdJBY0ivGJtHOA6K4rYSy7z20HowUUVcHdJQ@mail.gmail.com>
In-Reply-To: <CAES_P+-FDQKQSSSdJBY0ivGJtHOA6K4rYSy7z20HowUUVcHdJQ@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

noman pouigt wrote:
> x = 1;
> temp = atomic_read_increment(x);

atomic_set(&x, 1);
temp = atomic_inc_return(&x);

> I looked through the documentation for atomic
> operations but couldn't find out the api

Not everything is fully documented.

Look through include/asm-generic/atomic.h.


Regards,
Clemens
