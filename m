Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751623AbaG3WyZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 18:54:25 -0400
Received: from mail-qg0-f53.google.com ([209.85.192.53]:39405 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbaG3WyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 18:54:23 -0400
Message-ID: <53D9779A.7080003@twiddle.net>
Date: Wed, 30 Jul 2014 12:54:18 -1000
From: Richard Henderson <rth@twiddle.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Michael Cree <mcree@orcon.net.nz>
CC: linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org
Subject: Re: [PATCH 2/2] alpha: Add sched_set/getattr and renameat2 syscalls
References: <1406756552-23864-1-git-send-email-rth@twiddle.net> <1406756552-23864-3-git-send-email-rth@twiddle.net> <20140730222113.GC23324@stolen.phys.waikato.ac.nz>
In-Reply-To: <20140730222113.GC23324@stolen.phys.waikato.ac.nz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2014 12:21 PM, Michael Cree wrote:
> On Wed, Jul 30, 2014 at 11:42:32AM -1000, Richard Henderson wrote:
>> Signed-off-by: Richard Henderson <rth@twiddle.net>
>> ---
>>  arch/alpha/include/asm/unistd.h      | 2 +-
>>  arch/alpha/include/uapi/asm/unistd.h | 3 +++
>>  arch/alpha/kernel/systbls.S          | 3 +++
>>  3 files changed, 7 insertions(+), 1 deletion(-)
> 
> I thought Matt had already sent my patch to do just that to Linus.

Yes, I see now that he has.  Ignore my (exact) duplicate.


r~

