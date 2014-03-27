Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757158AbaC0TxG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 15:53:06 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:39313 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755024AbaC0TxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 15:53:03 -0400
Message-ID: <53348199.7070207@mit.edu>
Date: Thu, 27 Mar 2014 12:52:57 -0700
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Clemens Ladisch <clemens@ladisch.de>, Feng Tang <feng.tang@intel.com>,
        tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: hpet: Don't default CONFIG_HPET_TIMER to be y for
 X86_64
References: <1395906309-7519-1-git-send-email-feng.tang@intel.com> <53340561.4050708@ladisch.de>
In-Reply-To: <53340561.4050708@ladisch.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/27/2014 04:02 AM, Clemens Ladisch wrote:
> Feng Tang wrote:
>> On many new phone/tablet platforms like Baytrail/Merrifield etc,
>> the HPET are either defeatured or has some problem to be used
>> as a reliable timer. As these platforms also have X86_64, we
>> should not make HPET_TIMER default y for all X86_64.

Wouldn't it be better to fix the hpet driver so that the hpet doesn't
used on these platforms?

> 
> The help text still says:
> | You can safely choose Y here.  [...]
> | Choose N to continue using the legacy 8254 timer.
> 
> Are these statements still true for those platforms?

They aren't true for modern desktop and server platforms -- the TSC is
used regardless of hpet availability.

> 
> 
> Regards,
> Clemens
> 

