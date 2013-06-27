Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188Ab3F0WDm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 18:03:42 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:50576 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753727Ab3F0WDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 18:03:41 -0400
MIME-Version: 1.0
In-Reply-To: <CANeycqrP6n5GU-Ty17B2_6de_vruAxYNsOQ3WGSEAVDD=NBx2A@mail.gmail.com>
References: <1372123520-18287-1-git-send-email-wedsonaf@gmail.com>
	<20130625.162054.890870423042371628.davem@davemloft.net>
	<CANeycqrP6n5GU-Ty17B2_6de_vruAxYNsOQ3WGSEAVDD=NBx2A@mail.gmail.com>
Date: Thu, 27 Jun 2013 15:03:40 -0700
Message-ID: <CANeycqoqOPwEQqvvhQy3HJ8t7ViLORqvP3bpnP7zPeuLu1qMRA@mail.gmail.com>
Subject: Re: [PATCH v3] net: Unmap fragment page once iterator is done
From: Wedson Almeida Filho <wedsonaf@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Thomas Graf <tgraf@suug.ch>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> This patch doesn't even come close to applying to the net-next tree,
>> please respin this patch properly and resubmit.
>
> Where can I pull the net-next tree from?
> git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git?

David, would you mind clarifying where I can find net-next? The only
one I could find was the one I mention above and it already has my
patch in it (though with the previous comment).

Thanks
