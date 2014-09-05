Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457AbaIEPmY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 11:42:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48305 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753058AbaIEPmW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 11:42:22 -0400
Message-ID: <5409D9C0.7030403@zytor.com>
Date: Fri, 05 Sep 2014 08:41:52 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Peter Hurley <peter@hurleysoftware.com>
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
References: <20140712181328.GA8738@redhat.com>	 <54079B70.4050200@hurleysoftware.com> <1409785893.30640.118.camel@pasglop>	 <063D6719AE5E284EB5DD2968C1650D6D17487172@AcuExch.aculab.com> <1409824374.4246.62.camel@pasglop> <5408E458.3@zytor.com> <54090AF4.7060406@hurleysoftware.com> <54091B30.7080100@zytor.com> <5409D76D.2070203@hurleysoftware.com>
In-Reply-To: <5409D76D.2070203@hurleysoftware.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2014 08:31 AM, Peter Hurley wrote:
> 
> Which is a bit ironic because I remember when Digital had a team
> working on emulating native x86 apps on Alpha/NT.
> 

Right, because the x86 architecture was obsolete and would never scale...

	-hpa

