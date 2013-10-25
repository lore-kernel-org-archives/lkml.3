Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649Ab3JYNGw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 09:06:52 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:56563 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753309Ab3JYNGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 09:06:51 -0400
Date: Fri, 25 Oct 2013 09:06:36 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, sebastien.dugue@bull.net,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org
Subject: Re: [PATCH] x86: Run checksumming in parallel accross multiple alu's
Message-ID: <20131025130636.GC9281@hmsreliant.think-freely.org>
References: <1381510298-20572-1-git-send-email-nhorman@tuxdriver.com>
 <5259CD44.2000200@zytor.com>
 <20131018164218.GB4019@hmsreliant.think-freely.org>
 <b6c65074-a35e-4c50-8e97-096e48e0c506@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6c65074-a35e-4c50-8e97-096e48e0c506@email.android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 18, 2013 at 10:09:54AM -0700, H. Peter Anvin wrote:
> If implemented properly adcx/adox should give additional speedup... that is the whole reason for their existence.
> 
Ok, fair enough.  Unfotunately, I'm not going to be able to get my hands on a
stepping of this CPU to test any code using these instructions for some time, so
I'll back burner their use and revisit them later.  I'm still working on the
parallel alu/prefetch angle though.

Neil
