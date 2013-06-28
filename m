Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580Ab3F1AfR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 20:35:17 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:57921 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754534Ab3F1AfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 20:35:16 -0400
MIME-Version: 1.0
In-Reply-To: <20130627.162211.776450676036196766.davem@davemloft.net>
References: <20130625.162054.890870423042371628.davem@davemloft.net>
	<CANeycqrP6n5GU-Ty17B2_6de_vruAxYNsOQ3WGSEAVDD=NBx2A@mail.gmail.com>
	<CANeycqoqOPwEQqvvhQy3HJ8t7ViLORqvP3bpnP7zPeuLu1qMRA@mail.gmail.com>
	<20130627.162211.776450676036196766.davem@davemloft.net>
Date: Thu, 27 Jun 2013 17:35:15 -0700
Message-ID: <CANeycqq=XJXazHN0Ue3WcANPQCQ7kBvcwFbTtxAoS5_ZvkaKsA@mail.gmail.com>
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

On Thu, Jun 27, 2013 at 4:22 PM, David Miller <davem@davemloft.net> wrote:

>> David, would you mind clarifying where I can find net-next? The only
>> one I could find was the one I mention above and it already has my
>> patch in it (though with the previous comment).
>
> Yes that is where my net-next tree is, as clearly stated the
> "NETWORKING [GENERAL]" sercion of the MAINTAINERS file.

Ok, thanks for the info, now I know where the definitive answer is.

Anyway, why are you asking me to respin this patch? If I do it based
on this tree, there will be no changes in it.
