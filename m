Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751448Ab3HTNBj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 09:01:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15686 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750962Ab3HTNBh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 09:01:37 -0400
Message-ID: <1377003677.13412.5.camel@cr0>
Subject: Re: [Patch net-next v3 9/9] selinux: use generic union inet_addr
From: Cong Wang <amwang@redhat.com>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        james.l.morris@oracle.com, sds@tycho.nsa.gov, eparis@parisplace.org,
        pmoore@redhat.com, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Date: Tue, 20 Aug 2013 21:01:17 +0800
In-Reply-To: <5212915F.20905@schaufler-ca.com>
References: <1376907278-26377-1-git-send-email-amwang@redhat.com>
	 <1376907278-26377-10-git-send-email-amwang@redhat.com>
	 <52127336.3080209@schaufler-ca.com>
	 <20130819.125026.636442915180863272.davem@davemloft.net>
	 <5212915F.20905@schaufler-ca.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-08-19 at 14:42 -0700, Casey Schaufler wrote:
> 
> Well, they certainly don't appear to add any value on their own.
> I also generally oppose doing clever things with data structures. 

If you want to implement same thing for 5+ times, yes, it has no value
for you. Enjoy the following code in current tree:

union nf_inet_addr;
union sctp_addr;
union vxlan_addr; (in my VXLAN IPv6 patches, search email archives)
struct br_mdb_entry::addr;
union inet_addr; (in netpoll.h)

And may I tell you the last three are all from me? ;-)


