Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932156AbaJNIMy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 04:12:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33268 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932147AbaJNIMt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 04:12:49 -0400
Date: Tue, 14 Oct 2014 16:12:34 +0800
From: "'Dave Young'" <dyoung@redhat.com>
To: David Laight <David.Laight@ACULAB.COM>
Cc: "pablo@netfilter.org" <pablo@netfilter.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: nf_reject_ipv4: module license 'unspecified' taints kernel
Message-ID: <20141014081234.GB5357@dhcp-16-198.nay.redhat.com>
References: <20141010091904.GD1981@darkstar.nay.redhat.com>
 <063D6719AE5E284EB5DD2968C1650D6D174C8305@AcuExch.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D174C8305@AcuExch.aculab.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/14 at 09:53am, David Laight wrote:
> From: Dave Young
> > With today's linus tree, I got below kmsg:
> > [   23.545204] nf_reject_ipv4: module license 'unspecified' taints kernel.
> > [   23.551886] Disabling lock debugging due to kernel taint
> ...
> 
> Not 100% related, but why does loading a non-GPL module disable 
> lock debugging?
> (Is 'lock debugging' actually useful?)

I believe that we can not trust the debugging any more because kernel taint.. 

Thanks
Dave
