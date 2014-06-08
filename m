Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654AbaFHRvT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2014 13:51:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55438 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753565AbaFHRvR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2014 13:51:17 -0400
Message-ID: <5394A260.8000900@zytor.com>
Date: Sun, 08 Jun 2014 10:50:24 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>, Sitsofe Wheeler <sitsofe@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: Igor Mammedov <imammedo@redhat.com>, Toshi Kani <toshi.kani@hp.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [BISECTED][REGRESSION] Kernel does not boot on EeePC
References: <20140608090223.GA8703@sucs.org> <20140608094517.GB12736@gmail.com>
In-Reply-To: <20140608094517.GB12736@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08/2014 02:45 AM, Ingo Molnar wrote:
> 
> * Sitsofe Wheeler <sitsofe@gmail.com> wrote:
> 
>> Hi,
>>
>> The latest kernel (c593e8978722f7f4a12932733cfeed6c0c74fbaa) refuses to
>> boot on my EeePC - after grub is finished the screen just remains black
>> and the only thing that does something is pressing the power button. The
>> problem commit seems to be:
>>
>> commit 3e1a878b7ccdb31da6d9d2b855c72ad87afeba3f
>> Author: Igor Mammedov <imammedo@redhat.com>
>> Date:   Thu Jun 5 15:42:45 2014 +0200
>>
>>     x86/smpboot: Initialize secondary CPU only if master CPU will wait for it
> 
> Argh, and have read this just a minute after expressing my hope that 
> the hotplug fix is correct :-/
> 
> Linus, please revert commit 3e1a878b7ccdb.
> 
>   Acked-by: Ingo Molnar <mingo@kernel.org>
> 

I really want to say *THANK YOU* to Sitsofe for a very timely and
complete report.  You really saved us some highly valuable time.

	-hpa


