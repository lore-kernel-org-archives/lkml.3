Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753138Ab3GWCHs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 22:07:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56627 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751515Ab3GWCHq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 22:07:46 -0400
Message-ID: <1374545252.24933.6.camel@cr0>
Subject: Re: [Patch net-next 7/7] selinux: use generic union inet_addr
From: Cong Wang <amwang@redhat.com>
To: Paul Moore <pmoore@redhat.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        James Morris <james.l.morris@oracle.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Eric Paris <eparis@parisplace.org>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Date: Tue, 23 Jul 2013 10:07:32 +0800
In-Reply-To: <15803221.LSzpdzDYPS@sifl>
References: <1374476713-8838-1-git-send-email-amwang@redhat.com>
	 <1374476713-8838-8-git-send-email-amwang@redhat.com>
	 <15803221.LSzpdzDYPS@sifl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-07-22 at 16:36 -0400, Paul Moore wrote:
> 
> These changes are going to affect Smack as well.  You either need to respin 
> this patch to include all of the LSMs (Smack should be the only other affected 
> LSM) or add a new patch to the patchset.
> 

Yeah, I will include the Smack part as well.

Thanks!

