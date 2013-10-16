Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757588Ab3JPC76 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 22:59:58 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:50040 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918Ab3JPC75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 22:59:57 -0400
Message-ID: <525E011C.6010309@linux.vnet.ibm.com>
Date: Wed, 16 Oct 2013 08:29:40 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Sander Eikelenboom <linux@eikelenboom.it>
CC: linux-kernel@vger.kernel.org
Subject: Re: Kconfig help entry for CONFIG_PARAVIRT_SPINLOCK
References: <932951750.20131015234558@eikelenboom.it>
In-Reply-To: <932951750.20131015234558@eikelenboom.it>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13101602-8878-0000-0000-00000942440E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2013 03:15 AM, Sander Eikelenboom wrote:
> Hi Raghavendra,
>
> Since the ticketlock series have landed in this mergewindow (thanks :-) ) the
> help accompanying the Kconfig entry doesn't seem to reflect the current state well.
>
> - Wasn't the whole purpose of the ticketlock series to mitigate this 5% performance hit to something
>    far less, so distro kernels could enable this for their normal kernels ?
>    I don't have the exact performance figures though.
>
> - Perhaps the suggestion to enable this for supported hypervisors (Xen and KVM ?) could be added ?

You are right. Thanks. I 'll send the patch to change the config text
soon.


