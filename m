Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233AbaIJSgt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 14:36:49 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:42209 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754AbaIJSgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 14:36:47 -0400
Date: Wed, 10 Sep 2014 11:36:44 -0700 (PDT)
Message-Id: <20140910.113644.1584484249146625844.davem@davemloft.net>
To: Markos.Chandras@imgtec.com
Cc: dborkman@redhat.com, linux-kernel@vger.kernel.org, rdunlap@infradead.org,
        ast@plumgrid.com, linux-doc@vger.kernel.org
Subject: Re: [PATCH] Documentation: filter: Add MIPS to architectures with
 BPF JIT
From: David Miller <davem@davemloft.net>
In-Reply-To: <541050D0.1020302@imgtec.com>
References: <1409322218-3689-1-git-send-email-markos.chandras@imgtec.com>
	<54009D34.3010800@redhat.com>
	<541050D0.1020302@imgtec.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 10 Sep 2014 11:36:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markos Chandras <Markos.Chandras@imgtec.com>
Date: Wed, 10 Sep 2014 14:23:28 +0100

> On 08/29/2014 04:33 PM, Daniel Borkmann wrote:
>> On 08/29/2014 04:23 PM, Markos Chandras wrote:
>>> MIPS supports BPF JIT since v3.16-rc1
>>>
>>> Cc: Randy Dunlap <rdunlap@infradead.org>
>>> Cc: "David S. Miller" <davem@davemloft.net>
>>> Cc: Daniel Borkmann <dborkman@redhat.com>
>>> Cc: Alexei Starovoitov <ast@plumgrid.com>
>>> Cc: linux-doc@vger.kernel.org
>>> Signed-off-by: Markos Chandras <markos.chandras@imgtec.com>
>> 
>> Acked-by: Daniel Borkmann <dborkman@redhat.com>
> Hi,
> 
> I think this hasn't been merged yet (I can't see it in mainline or
> linux-next). Do I need to ping someone or does it have to go via the
> MIPS tree?

Well, patches not even CC:'d to netdev won't be going into the networking
tree if that is what you expected.
