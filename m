Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761018Ab3DBORg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 10:17:36 -0400
Received: from mail.skyhub.de ([78.46.96.112]:53593 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756127Ab3DBORf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 10:17:35 -0400
Date: Tue, 2 Apr 2013 16:17:32 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Tony Luck <tony.luck@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>, Chen Gong <gong.chen@linux.intel.com>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, andi@firstfloor.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, tony.luck@gmail.com
Subject: Re: [PATCH] x86/mce: Rework cmci_rediscover() to play well with CPU
 hotplug
Message-ID: <20130402141732.GA4391@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
	Tony Luck <tony.luck@intel.com>, Ingo Molnar <mingo@kernel.org>,
	Chen Gong <gong.chen@linux.intel.com>,
	Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, x86@kernel.org,
	Thomas Gleixner <tglx@linutronix.de>, andi@firstfloor.org,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	tony.luck@gmail.com
References: <20130319224408.GB18152@redhat.com>
 <20130320031647.GA13311@gchen.bj.intel.com>
 <514988F9.2000005@linux.vnet.ibm.com>
 <515AE64B.7080804@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <515AE64B.7080804@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 02, 2013 at 07:38:11PM +0530, Srivatsa S. Bhat wrote:
> Tony mentioned that this patch worked fine for him. So could you
> kindly pick up this patch?

Normally, Tony picks up the Intel side of MCE. Tony, want me to do it?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
