Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146AbaFFTRo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 15:17:44 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:44223 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361AbaFFTRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 15:17:42 -0400
Date: Fri, 6 Jun 2014 23:17:38 +0400
From: Dmitry Popov <ixaphire@qrator.net>
To: "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH] ipip, sit: fix ipv4_{update_pmtu,redirect} calls
Message-Id: <20140606231738.80a0a6d316d34eab5cd9cbf1@qrator.net>
In-Reply-To: <20140606225117.684592168760890b595a166d@qrator.net>
References: <20140606225117.684592168760890b595a166d@qrator.net>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jun 2014 22:51:17 +0400
Dmitry Popov <ixaphire@qrator.net> wrote:

> ipv4_{update_pmtu,redirect) were called with tunnel's ifindex (t->dev is a 

Should be read as 
ipv4_{update_pmtu,redirect} ...

I will resubmit the patch, sorry. :(
