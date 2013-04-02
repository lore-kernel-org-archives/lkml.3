Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760794Ab3DBSSd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 14:18:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:54613 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760013Ab3DBSSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 14:18:31 -0400
Message-ID: <515B12EB.50303@infradead.org>
Date: Tue, 02 Apr 2013 10:18:35 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>,
        linux-security-module <linux-security-module@vger.kernel.org>
Subject: Re: linux-next: Tree for Apr 2 (smack)
References: <20130402190929.62cea8988921a2599588a566@canb.auug.org.au>
In-Reply-To: <20130402190929.62cea8988921a2599588a566@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/13 01:09, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20130328:
> 


on x86_64:

security/smack/smackfs.c: In function 'smk_fill_super':
security/smack/smackfs.c:2221:29: error: 'SMACK_MAGIC' undeclared (first use in this function)


Needs to
#include <linux/magic.h>


-- 
~Randy
