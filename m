Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751643Ab3HTOzv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 10:55:51 -0400
Received: from moth.iki.fi ([212.16.111.74]:37816 "EHLO moth.iki.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751251Ab3HTOzt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 10:55:49 -0400
X-Greylist: delayed 453 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Aug 2013 10:55:48 EDT
Message-ID: <521381A0.9050304@moth.iki.fi>
Date: Tue, 20 Aug 2013 17:48:00 +0300
From: Markku Savela <msa@moth.iki.fi>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Casey Schaufler <casey@schaufler-ca.com>
CC: Cong Wang <amwang@redhat.com>, David Miller <davem@davemloft.net>,
        netdev@vger.kernel.org, james.l.morris@oracle.com, sds@tycho.nsa.gov,
        eparis@parisplace.org, pmoore@redhat.com, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: Re: [Patch net-next v3 9/9] selinux: use generic union inet_addr
References: <1376907278-26377-1-git-send-email-amwang@redhat.com>  <1376907278-26377-10-git-send-email-amwang@redhat.com>  <52127336.3080209@schaufler-ca.com>  <20130819.125026.636442915180863272.davem@davemloft.net>  <5212915F.20905@schaufler-ca.com> <1377003677.13412.5.camel@cr0> <52137CFF.70601@schaufler-ca.com>
In-Reply-To: <52137CFF.70601@schaufler-ca.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Imho, the patch doesn't go far enough actually. What should be done:

- get rid of the union
- use IPv6 format only
- store IPv4 addresses in IPv4 mapped format


