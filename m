Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754388Ab3KUPdE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 10:33:04 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:61864 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827Ab3KUPdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 10:33:01 -0500
Message-ID: <1385047978.10637.51.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH 1/4] bonding: L2DA mode added
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Anton Nayshtut <Anton.Nayshtut@wilocity.com>
Cc: Jay Vosburgh <fubar@us.ibm.com>, Veaceslav Falico <vfalico@redhat.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Nicolas Schichan <nschichan@freebox.fr>,
        Eric Dumazet <edumazet@google.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org,
        Erez Kirshenbaum <Erez.Kirshenbaum@wilocity.com>,
        Boris Lapshin <Boris.Lapshin@wilocity.com>
Date: Thu, 21 Nov 2013 07:32:58 -0800
In-Reply-To: <1385045738-29726-2-git-send-email-Anton.Nayshtut@wilocity.com>
References: <1385045738-29726-1-git-send-email-Anton.Nayshtut@wilocity.com>
	 <1385045738-29726-2-git-send-email-Anton.Nayshtut@wilocity.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-11-21 at 16:55 +0200, Anton Nayshtut wrote:
> This patches introduces L2DA bonding module with all the data structures and
> interfaces. It's not integrated yet.

I veto any kind of new bonding mode not using RCU.

Adding another rwlock in 2013 is simply not an option.

Thanks


