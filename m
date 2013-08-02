Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753015Ab3HBOeS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 10:34:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13461 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750948Ab3HBOeQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 10:34:16 -0400
From: Paul Moore <pmoore@redhat.com>
To: Cong Wang <amwang@redhat.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        James Morris <james.l.morris@oracle.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Eric Paris <eparis@parisplace.org>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: Re: [Patch net-next v2 8/8] selinux: use generic union inet_addr
Date: Fri, 02 Aug 2013 10:34:07 -0400
Message-ID: <4528870.px4VD3WrY3@sifl>
Organization: Red Hat
User-Agent: KMail/4.10.5 (Linux/3.10.2-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1375427674-21735-9-git-send-email-amwang@redhat.com>
References: <1375427674-21735-1-git-send-email-amwang@redhat.com> <1375427674-21735-9-git-send-email-amwang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, August 02, 2013 03:14:34 PM Cong Wang wrote:
> From: Cong Wang <amwang@redhat.com>
> 
> selinux has some similar definition like union inet_addr,
> it can re-use the generic union inet_addr too.
> 
> Cc: James Morris <james.l.morris@oracle.com>
> Cc: Stephen Smalley <sds@tycho.nsa.gov>
> Cc: Eric Paris <eparis@parisplace.org>
> Cc: Paul Moore <pmoore@redhat.com>
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-security-module@vger.kernel.org
> Signed-off-by: Cong Wang <amwang@redhat.com>

Perhaps I'm confusing this with another patch but I though DaveM said he 
wasn't going to merge these patches?

-- 
paul moore
security and virtualization @ redhat

