Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887AbaIEPcP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 11:32:15 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:42942 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751271AbaIEPcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 11:32:12 -0400
Message-ID: <5409D76D.2070203@hurleysoftware.com>
Date: Fri, 05 Sep 2014 11:31:57 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Laight <David.Laight@ACULAB.COM>,
        Jakub Jelinek <jakub@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Tony Luck <tony.luck@intel.com>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Miroslav Franc <mfranc@redhat.com>,
        Richard Henderson <rth@twiddle.net>, linux-alpha@vger.kernel.org
Subject: Re: bit fields && data tearing
References: <20140712181328.GA8738@redhat.com>	 <54079B70.4050200@hurleysoftware.com> <1409785893.30640.118.camel@pasglop>	 <063D6719AE5E284EB5DD2968C1650D6D17487172@AcuExch.aculab.com> <1409824374.4246.62.camel@pasglop> <5408E458.3@zytor.com> <54090AF4.7060406@hurleysoftware.com> <54091B30.7080100@zytor.com>
In-Reply-To: <54091B30.7080100@zytor.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2014 10:08 PM, H. Peter Anvin wrote:
> On 09/04/2014 05:59 PM, Peter Hurley wrote:
>> I have no idea how prevalent the ev56 is compared to the ev5.
>> Still we're talking about a chip that came out in 1996.
> 
> Ah yes, I stand corrected.  According to Wikipedia, the affected CPUs
> were all the 2106x CPUs (EV4, EV45, LCA4, LCA45) plus the 21164 with no
> suffix (EV5).  However, we're still talking about museum pieces here.
> 
> I wonder what the one I have in my garage is... I'm sure I could emulate
> it faster, though.

Which is a bit ironic because I remember when Digital had a team
working on emulating native x86 apps on Alpha/NT.

