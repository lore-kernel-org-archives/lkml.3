Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932350AbaGaJNp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 05:13:45 -0400
Received: from mail.skyhub.de ([78.46.96.112]:55410 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932253AbaGaJNn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 05:13:43 -0400
Date: Thu, 31 Jul 2014 11:13:34 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Chen, Gong" <gong.chen@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, tglx@linutronix.de,
        paulus@samba.org, benh@kernel.crashing.org, tony.luck@intel.com,
        hpa@zytor.com, jkosina@suse.cz, rafael.j.wysocki@intel.com,
        linux@arm.linux.org.uk, ralf@linux-mips.org, schwidefsky@de.ibm.com,
        davem@davemloft.net, viro@zeniv.linux.org.uk, fweisbec@gmail.com,
        cl@linux.com, akpm@linux-foundation.org, axboe@kernel.dk,
        JBottomley@parallels.com, neilb@suse.de, christoffer.dall@linaro.org,
        rostedt@goodmis.org, rric@kernel.org, gregkh@linuxfoundation.org,
        mhocko@suse.cz, david@fromorbit.com
Subject: Re: [RFC PATCH v1 13/70] x86, x2apic_cluster: _FROZEN Cleanup
Message-ID: <20140731091334.GA20890@pd.tnic>
References: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
 <1406080786-3938-14-git-send-email-gong.chen@linux.intel.com>
 <20140723203628.GJ21707@pd.tnic>
 <20140730062415.GA5100@gchen.bj.intel.com>
 <20140730084852.GA10213@pd.tnic>
 <20140731075234.GA26585@gchen.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140731075234.GA26585@gchen.bj.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2014 at 03:52:34AM -0400, Chen, Gong wrote:
> I'm silly. You are right. I will use your patch directly(I should do
> it at the beginning :-)).

I think it is still ok that we talked about this, it can easily be
gotten wrong.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
