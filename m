Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202Ab3DUKeG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 06:34:06 -0400
Received: from mail.skyhub.de ([78.46.96.112]:45764 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753048Ab3DUKeF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 06:34:05 -0400
Date: Sun, 21 Apr 2013 12:34:03 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: x86-ml <x86@kernel.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: irq 16: nobody cared
Message-ID: <20130421103403.GA4594@pd.tnic>
References: <20130420185330.GA4654@pd.tnic>
 <20130420235206.GA3509@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130420235206.GA3509@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 20, 2013 at 04:52:07PM -0700, Paul E. McKenney wrote:
> Hmmm... Does this problem occur only with CONFIG_RCU_FAST_NO_HZ=y, or
> does it occur unconditionally? (My guess is the former, but figured I
> should check.)

Your guess is correct, sir.

>From quickly grepping in /boot/, I have CONFIG_RCU_FAST_NO_HZ=y in all
my 3.9 configs. So I went and turned it off and the issue doesn't appear
anymore.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
