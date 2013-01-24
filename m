Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005Ab3AXOnh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 09:43:37 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44381 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753311Ab3AXOnf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 09:43:35 -0500
Date: Thu, 24 Jan 2013 15:46:12 +0100
From: Borislav Petkov <bp@suse.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: ling.ma.program@gmail.com, mingo@redhat.com, tglx@linutronix.de,
        hpa@zytor.com, linux-kernel@vger.kernel.org,
        Ma Ling <ling.ml@alipay.com>
Subject: Re: [Suggestion] [x86]: Compiler Option Os is better on latest x86
Message-ID: <20130124144612.GC13471@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@suse.de>,
	Ingo Molnar <mingo@kernel.org>, ling.ma.program@gmail.com,
	mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com,
	linux-kernel@vger.kernel.org, Ma Ling <ling.ml@alipay.com>
References: <1356503537-4987-1-git-send-email-ling.ma@alipay.com>
 <20130124141733.GA14876@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130124141733.GA14876@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2013 at 03:17:33PM +0100, Ingo Molnar wrote:
> > So our initial conclusion is Os is better than O2 for current 
> > & coming x86 CPUs. If I was wrong, please correct me.
> 
> Did you patch the kernel, or used CONFIG_CC_OPTIMIZE_FOR_SIZE?
> 
> (there was no patch in your mail.)

Hmm, I'm not sure about -Os: 3a55fb0d9fe8e2f4594329edd58c5fd6f35a99dd

And 0.01/0.03 IPC improvement doesn't really look too persuasive IMO.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
