Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753021AbaBCPqI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 10:46:08 -0500
Received: from www.aws-it.at ([83.218.181.38]:56308 "EHLO bigboss.aws-it.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752962AbaBCPqE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 10:46:04 -0500
Date: Mon, 03 Feb 2014 16:46:01 +0100
Message-ID: <20140203164601.Horde.d6qSBqHukBoUna_PtOIzfA6@aws-it.at>
From: astx <astx@aws-it.at>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>,
        netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: OOPS in nf_ct_unlink_expect_report using Polycom RealPresence
 Mobile
References: <20140131120527.Horde.-3YzQu5S8WWBx7vuVVNdBA2@bigboss.aws-it.at>
 <20140131125014.Horde.G2TRlt-60JJ0Nl_3Y8IniQ2@bigboss.aws-it.at>
 <20140131170402.Horde.yIFUeQVjLycuS_8PGQoKmg5@aws-it.at>
 <20140203121415.GA12777@localhost>
In-Reply-To: <20140203121415.GA12777@localhost>
User-Agent: Internet Messaging Program (IMP) H5 (6.0.4)
Content-Type: text/plain; charset=UTF-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Test results / tested kernel versions:

3.2.54
3.8.13
3.10.28

Above kernel versions without patch are dying with same error on  
trying to start h323 connections using "Polycom RealPresence Mobile".

I can confirm that with this patch all three kernel versions are  
pretty stable now again.

Thank you all for your fast and competent help.

Best Regards,

Toni


Zitat von Pablo Neira Ayuso <pablo@netfilter.org>:

> On Fri, Jan 31, 2014 at 05:04:02PM +0100, astx wrote:
>> Dear Alexey,
>>
>> seems to help. Thank you for your quick response. Kernel 3.10.28 is
>> now stable using h323 / Polycom.
>
> Thanks, if no objection, will pass this patch to David.



