Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932244AbaIIKBt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 06:01:49 -0400
Received: from mail.us.es ([193.147.175.20]:36532 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755427AbaIIKBr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 06:01:47 -0400
X-Qmail-Scanner-Diagnostics: from 127.0.0.1 by antivirus3 (envelope-from <pneira@us.es>, uid 501) with qmail-scanner-2.10 
 (clamdscan: 0.98.4/19346. spamassassin: 3.3.2.  
 Clear:RC:1(127.0.0.1):SA:0(-103.0/7.5):. 
 Processed in 1.810363 secs); 09 Sep 2014 10:01:44 -0000
X-Spam-ASN: AS12715 87.216.0.0/16
X-Envelope-From: pneira@us.es
Date: Tue, 9 Sep 2014 12:02:40 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Bojan Prtvar <prtvar.b@gmail.com>
Cc: kaber@trash.net, kadlec@blackhole.kfki.hu, davem@davemloft.net,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfilter: xtables:  Remove unnecessary initialization
 of struct ts_state
Message-ID: <20140909100240.GA11567@salvia>
References: <1410162672-5040-1-git-send-email-prtvar.b@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410162672-5040-1-git-send-email-prtvar.b@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2014 at 09:51:12AM +0200, Bojan Prtvar wrote:
> The skb_find_text() accepts uninitialized textsearch state variable.

Applied, thanks.

