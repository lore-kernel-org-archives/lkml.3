Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428AbaIDWQF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 18:16:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39128 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751163AbaIDWQD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 18:16:03 -0400
Message-ID: <5408E458.3@zytor.com>
Date: Thu, 04 Sep 2014 15:14:48 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Laight <David.Laight@ACULAB.COM>
CC: Peter Hurley <peter@hurleysoftware.com>, Jakub Jelinek <jakub@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Tony Luck <tony.luck@intel.com>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Miroslav Franc <mfranc@redhat.com>,
        Richard Henderson <rth@twiddle.net>
Subject: Re: bit fields && data tearing
References: <20140712181328.GA8738@redhat.com>	 <54079B70.4050200@hurleysoftware.com> <1409785893.30640.118.camel@pasglop>	 <063D6719AE5E284EB5DD2968C1650D6D17487172@AcuExch.aculab.com> <1409824374.4246.62.camel@pasglop>
In-Reply-To: <1409824374.4246.62.camel@pasglop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2014 02:52 AM, Benjamin Herrenschmidt wrote:
> 
> Yeah correct, alpha and bytes right ? Is there any other ? That's why I
> suggested int.
> 

Even for Alpha it is only the 21064 AFAIK.

	-hpa


