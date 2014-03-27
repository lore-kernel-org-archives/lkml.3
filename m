Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983AbaC0LDB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 07:03:01 -0400
Received: from dehamd003.servertools24.de ([31.47.254.18]:33089 "EHLO
	dehamd003.servertools24.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755415AbaC0LDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 07:03:00 -0400
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
Message-ID: <53340561.4050708@ladisch.de>
Date: Thu, 27 Mar 2014 12:02:57 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Feng Tang <feng.tang@intel.com>, tglx@linutronix.de, mingo@elte.hu,
        hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: hpet: Don't default CONFIG_HPET_TIMER to be y for
 X86_64
References: <1395906309-7519-1-git-send-email-feng.tang@intel.com>
In-Reply-To: <1395906309-7519-1-git-send-email-feng.tang@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Feng Tang wrote:
> On many new phone/tablet platforms like Baytrail/Merrifield etc,
> the HPET are either defeatured or has some problem to be used
> as a reliable timer. As these platforms also have X86_64, we
> should not make HPET_TIMER default y for all X86_64.

The help text still says:
| You can safely choose Y here.  [...]
| Choose N to continue using the legacy 8254 timer.

Are these statements still true for those platforms?


Regards,
Clemens
