Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756889Ab3HGCnJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 22:43:09 -0400
Received: from intranet.asianux.com ([58.214.24.6]:62195 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756833Ab3HGCnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 22:43:08 -0400
X-Spam-Score: -100.8
Message-ID: <5201B3FC.8040405@asianux.com>
Date: Wed, 07 Aug 2013 10:42:04 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: "'Jiri Kosina'" <trivial@kernel.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, davej@redhat.com,
        Arnd Bergmann <arnd@arndb.de>, David Miller <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH trivial] UAPI: Kbuild: add/modify comments for "uapi/Kbuild"
 and "uapi/linux/Kbuild"
References: <52005571.4080704@asianux.com> <1375810303.2424.28.camel@joe-AO722>
In-Reply-To: <1375810303.2424.28.camel@joe-AO722>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2013 01:31 AM, Joe Perches wrote:
> On Tue, 2013-08-06 at 09:46 +0800, Chen Gang wrote:
>> "include/uapi/" is the whole Linux kernel API, it is important enough
>> to get more global explanations by comments.
> 
> It'd probably be useful to have more descriptions
> of uapi in the Documentation directory too.
> 

Yeah, at least, I also think so.

Since it is an 'important' document, I recommend to let it written by an
'important' member, and be discussed or checked by all related members.

But for what I did (this patch) is mainly for the summary comments. So I
think it is enough to be discussed and checked by the members which
"./scripts/get_maintainers.pl" suggests.


Thanks.
-- 
Chen Gang
