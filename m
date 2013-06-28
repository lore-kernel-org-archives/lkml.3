Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568Ab3F1BEi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 21:04:38 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:33740 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754260Ab3F1BEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 21:04:37 -0400
Date: Thu, 27 Jun 2013 18:04:34 -0700 (PDT)
Message-Id: <20130627.180434.499291228477667042.davem@davemloft.net>
To: wedsonaf@gmail.com
Cc: sergei.shtylyov@cogentembedded.com, tgraf@suug.ch, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] net: Unmap fragment page once iterator is done
From: David Miller <davem@davemloft.net>
In-Reply-To: <CANeycqq=XJXazHN0Ue3WcANPQCQ7kBvcwFbTtxAoS5_ZvkaKsA@mail.gmail.com>
References: <CANeycqoqOPwEQqvvhQy3HJ8t7ViLORqvP3bpnP7zPeuLu1qMRA@mail.gmail.com>
	<20130627.162211.776450676036196766.davem@davemloft.net>
	<CANeycqq=XJXazHN0Ue3WcANPQCQ7kBvcwFbTtxAoS5_ZvkaKsA@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wedson Almeida Filho <wedsonaf@gmail.com>
Date: Thu, 27 Jun 2013 17:35:15 -0700

> On Thu, Jun 27, 2013 at 4:22 PM, David Miller <davem@davemloft.net> wrote:
> 
>>> David, would you mind clarifying where I can find net-next? The only
>>> one I could find was the one I mention above and it already has my
>>> patch in it (though with the previous comment).
>>
>> Yes that is where my net-next tree is, as clearly stated the
>> "NETWORKING [GENERAL]" sercion of the MAINTAINERS file.
> 
> Ok, thanks for the info, now I know where the definitive answer is.
> 
> Anyway, why are you asking me to respin this patch? If I do it based
> on this tree, there will be no changes in it.

Nevermind then.
