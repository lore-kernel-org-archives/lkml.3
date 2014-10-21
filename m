Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933683AbaJUVQ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 17:16:26 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:33190 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933503AbaJUVQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 17:16:24 -0400
MIME-Version: 1.0
In-Reply-To: <1413911624662.86334@microsoft.com>
References: <1412530971-29897-1-git-send-email-kys@microsoft.com>
	<20141005.211129.632749242463744635.davem@davemloft.net>
	<20141009133200.GA17134@sucs.org>
	<96f3d4f6b90a461686b23f64aedcb4fc@BL2PR03MB132.namprd03.prod.outlook.com>
	<20141011103630.GA22272@sucs.org>
	<1413911624662.86334@microsoft.com>
Date: Tue, 21 Oct 2014 22:16:22 +0100
Message-ID: <CALjAwxj1jHUugt+vtJL7duXfTpdoxmCrwTzRmNHGgOdj+Ju3Aw@mail.gmail.com>
Subject: Re: [PATCH net 1/1] hyperv: Fix a bug in netvsc_send()
From: Sitsofe Wheeler <sitsofe@gmail.com>
To: Long Li <longli@microsoft.com>
Cc: David Miller <davem@davemloft.net>, "olaf@aepfle.de" <olaf@aepfle.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "apw@canonical.com" <apw@canonical.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        Haiyang Zhang <haiyangz@microsoft.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 October 2014 18:13, Long Li <longli@microsoft.com> wrote:
> Thanks Sitsofe. This should have been fixed by this patch:
> http://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/commit/?id=f88e67149f97d73c704d6fe6f492edde97463025
>
> Can you give it a try?

Ah this one went mainline a few days ago so I've already been trying
it. Yes it resolves my problem (that system is no longer oopsing on
startup). I'd have added my Tested-by but it's already been committed
:-)

What helped you narrow it down?

-- 
Sitsofe | http://sucs.org/~sits/
