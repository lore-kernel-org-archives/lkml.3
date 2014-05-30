Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065AbaE3OhX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 10:37:23 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:51269 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755624AbaE3OhV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 10:37:21 -0400
Date: Fri, 30 May 2014 07:37:18 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: David Miller <davem@davemloft.net>
Cc: linus.luessing@web.de, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        b.a.t.m.a.n@lists.open-mesh.org
Subject: Re: [PATCHv2 net-next 0/4] bridge: multicast snooping patches /
 exports
Message-ID: <20140530073718.27e21e38@nehalam.linuxnetplumber.net>
In-Reply-To: <20140529.153622.764478286337271648.davem@davemloft.net>
References: <1400994205-31165-1-git-send-email-linus.luessing@web.de>
	<20140529.153622.764478286337271648.davem@davemloft.net>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 May 2014 15:36:22 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> From: Linus Lüssing <linus.luessing@web.de>
> Date: Sun, 25 May 2014 07:03:21 +0200
> 
> > Changes in v2:
> 
> I really need a bridging expert to review this series, thank you.

I am fine with these, but would like original author of IGMP snooping
to weigh in.
