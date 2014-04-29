Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965052AbaD2TCy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 15:02:54 -0400
Received: from mail.us.es ([193.147.175.20]:48303 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933447AbaD2TCx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 15:02:53 -0400
X-Qmail-Scanner-Diagnostics: from 127.0.0.1 by antivirus5 (envelope-from <pneira@us.es>, uid 501) with qmail-scanner-2.10 
 (clamdscan: 0.98.1/18885. spamassassin: 3.3.2.  
 Clear:RC:1(127.0.0.1):SA:0(-101.2/7.5):. 
 Processed in 2.229148 secs); 29 Apr 2014 19:02:50 -0000
X-Spam-ASN: AS12715 87.216.0.0/16
X-Envelope-From: pneira@us.es
Date: Tue, 29 Apr 2014 21:02:46 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Cc: Masanari Iida <standby24x7@gmail.com>, netdev@vger.kernel.org,
        kadlec@blackhole.kfki.hu, netfilter-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] netfilter: Fix format string mismatch in
 mangle_content_len()
Message-ID: <20140429190246.GA9993@localhost>
References: <1396280619-31152-1-git-send-email-standby24x7@gmail.com>
 <20140429142119.GA12499@macbook.localnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140429142119.GA12499@macbook.localnet>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2014 at 03:21:21PM +0100, Patrick McHardy wrote:
> On Tue, Apr 01, 2014 at 12:43:36AM +0900, Masanari Iida wrote:
> > Fix format string mismatch in mangle_connect_len()
> 
> All these patches seem like pointless noise to me. In none of these
> cases can the value legitimately be negative. If anything, you should
> fix the types to be unsigned.

Let's do that instead. I'm going to remove these oneliners from the
nf-next queue, thanks Patrick.
