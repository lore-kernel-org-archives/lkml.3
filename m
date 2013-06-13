Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758888Ab3FMWiq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 18:38:46 -0400
Received: from mail.skyhub.de ([78.46.96.112]:33660 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757849Ab3FMWin (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 18:38:43 -0400
Date: Fri, 14 Jun 2013 00:38:41 +0200
From: Borislav Petkov <bp@alien8.de>
To: Stratos Karafotis <stratosk@semaphore.gr>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Borislav Petkov <bp@suse.de>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pm@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/3] cpufreq: ondemand: Change the calculation of
 target frequency
Message-ID: <20130613223841.GF32112@pd.tnic>
References: <q46r5iepl3sunqe5eemv66hk.1370694869222@email.android.com>
 <7661669.NhG4BEI8zO@vostro.rjw.lan>
 <51B64BC6.6040400@semaphore.gr>
 <16929930.1G36b4NkSe@vostro.rjw.lan>
 <51BA380A.1040009@semaphore.gr>
 <20130613214007.GA32127@pd.tnic>
 <51BA41E9.8020004@semaphore.gr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <51BA41E9.8020004@semaphore.gr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 14, 2013 at 01:04:25AM +0300, Stratos Karafotis wrote:
> I believe that ondemand has better performance with this patch in
> medium loads. Maybe these operations produce small to medium loads
> (lower than up_threshold) and push the CPU to medium frequencies.
> Without the patch CPU stays longer to min frequency.

Yep, this is my impression too.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
