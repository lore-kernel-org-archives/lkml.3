Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753694Ab3EOWoH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 18:44:07 -0400
Received: from mail.skyhub.de ([78.46.96.112]:33446 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752645Ab3EOWoF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 18:44:05 -0400
Date: Thu, 16 May 2013 00:43:58 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Frederic Weisbecker <fweisbec@gmail.com>,
        Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: NOHZ: WARNING: at arch/x86/kernel/smp.c:123
 native_smp_send_reschedule
Message-ID: <20130515224358.GF11783@pd.tnic>
References: <alpine.LNX.2.00.1305091423460.23038@pobox.suse.cz>
 <20130509125040.GF27333@pd.tnic>
 <20130509125859.GG27333@pd.tnic>
 <20130515184528.GO4442@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130515184528.GO4442@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 15, 2013 at 11:45:28AM -0700, Paul E. McKenney wrote:
> Does the following patch help?

Hmm, I just tried on 3.10-rc1

CONFIG_NO_HZ_FULL_ALL=y

on the one hand and then

CONFIG_NO_HZ_FULL=y
# CONFIG_NO_HZ_FULL_ALL is not set

with "nohz_full=4-7 rcu_nocbs=4-7" on the cmdline and I don't see the
splats anymore.

Do I need to try something else?

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
