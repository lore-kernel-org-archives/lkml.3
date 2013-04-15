Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771Ab3DOOCp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 10:02:45 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:41377 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911Ab3DOOCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 10:02:44 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org
Subject: Re: [PATCH 1/3] cputime_nsecs: use math64.h for nsec resolution conversion helpers
References: <1363822467-6275-1-git-send-email-khilman@linaro.org>
	<1363822467-6275-2-git-send-email-khilman@linaro.org>
	<20130411171047.GB17129@somewhere.redhat.com>
Date: Mon, 15 Apr 2013 07:02:40 -0700
In-Reply-To: <20130411171047.GB17129@somewhere.redhat.com> (Frederic
	Weisbecker's message of "Thu, 11 Apr 2013 19:10:50 +0200")
Message-ID: <87r4ibdh8f.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker <fweisbec@gmail.com> writes:

> On Wed, Mar 20, 2013 at 04:34:25PM -0700, Kevin Hilman wrote:
>> For the nsec resolution conversions to be useable on non 64-bit
>> architectures, the helpers in <linux/math64.h> need to be used so the
>> right arch-specific 64-bit math helpers can be used (e.g. do_div())
>> 
>> Cc: Frederic Weisbecker <fweisbec@gmail.com>
>> Signed-off-by: Kevin Hilman <khilman@linaro.org>
>
> Ok the patch is nice!
>
> I'm queuing it.

Thanks, did you queue PATCH 3/3 also to remove the 64-bit limitation
from VIRT_CPU_ACCOUNTING_GEN:  https://lkml.org/lkml/2013/3/20/656

Kevin
