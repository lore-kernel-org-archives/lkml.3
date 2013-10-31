Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297Ab3JaGhu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 02:37:50 -0400
Received: from intranet.asianux.com ([58.214.24.6]:59446 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691Ab3JaGhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 02:37:48 -0400
X-Spam-Score: -100.8
Message-ID: <5271FA7E.9050103@asianux.com>
Date: Thu, 31 Oct 2013 14:36:46 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
CC: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Mike Frysinger <vapier@gentoo.org>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>, Arnd Bergmann <arnd@arndb.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        realmz paranoid <realmz6@gmail.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "uclinux-dist-devel@blackfin.uclinux.org" 
	<uclinux-dist-devel@blackfin.uclinux.org>,
        Parisc List <linux-parisc@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] arch: *: remove '__init' for setup_profiling_timer()
References: <52672ECD.9010800@asianux.com> <C2D7FE5348E1B147BCA15975FBA23075153861@IN01WEMBXA.internal.synopsys.com> <5271F4A9.40804@asianux.com> <5271F54F.8070607@asianux.com> <C2D7FE5348E1B147BCA15975FBA230751538BE@IN01WEMBXA.internal.synopsys.com>
In-Reply-To: <C2D7FE5348E1B147BCA15975FBA230751538BE@IN01WEMBXA.internal.synopsys.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/2013 02:22 PM, Vineet Gupta wrote:
> On 10/31/2013 11:45 AM, Chen Gang wrote:
>> > Hmm... if so, recommend to modify another architectures which also only
>> > return "-EINVAL", but without "__init" prefix.
> Yes in first pass, it will only convert the arches which return EINVAL but can ask
> the maintainers whether they want the alternate versions too.
> 

Yes.

> So you want to take a stab at this series.

If you have time, please help send.

In 1st half of next month, I will/should turn back to do another things
(e.g. use test tools and read code to find issues, and try to solve them).


Thanks.
-- 
Chen Gang
