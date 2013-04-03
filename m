Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760942Ab3DCCOY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 22:14:24 -0400
Received: from tundra.namei.org ([65.99.196.166]:39142 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759307Ab3DCCOX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 22:14:23 -0400
Date: Wed, 3 Apr 2013 13:15:51 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Randy Dunlap <rdunlap@infradead.org>
cc: Casey Schaufler <casey@schaufler-ca.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-security-module <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH] Smack: include magic.h in smackfs.c
In-Reply-To: <515B4EEC.8000908@infradead.org>
Message-ID: <alpine.LRH.2.02.1304031315380.25743@tundra.namei.org>
References: <20130402190929.62cea8988921a2599588a566@canb.auug.org.au> <515B12EB.50303@infradead.org> <515B264E.2020603@schaufler-ca.com> <515B4EEC.8000908@infradead.org>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Apr 2013, Randy Dunlap wrote:

> On 04/02/13 11:41, Casey Schaufler wrote:
> > As reported for linux-next: Tree for Apr 2 (smack)
> > Add the required include for smackfs.c
> > 
> > Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
> 
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Acked-by: Randy Dunlap <rdunlap@infradead.org>
> 

Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git next


-- 
James Morris
<jmorris@namei.org>
