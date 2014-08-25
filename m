Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751278AbaHYIiS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 04:38:18 -0400
Received: from mail.us.es ([193.147.175.20]:54174 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750858AbaHYIiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 04:38:16 -0400
X-Qmail-Scanner-Diagnostics: from 127.0.0.1 by antivirus4 (envelope-from <pneira@us.es>, uid 501) with qmail-scanner-2.10 
 (clamdscan: 0.98.4/19307. spamassassin: 3.3.2.  
 Clear:RC:1(127.0.0.1):SA:0(-103.0/7.5):. 
 Processed in 5.24094 secs); 25 Aug 2014 08:38:14 -0000
X-Spam-ASN: AS12715 87.216.0.0/16
X-Envelope-From: pneira@us.es
Date: Mon, 25 Aug 2014 10:38:57 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Zhouyi Zhou <zhouzhouyi@gmail.com>
Cc: fw@strlen.de, kaber@trash.net, kadlec@blackhole.kfki.hu,
        davem@davemloft.net, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jbaron@akamai.com,
        Zhouyi Zhou <yizhouzhou@ict.ac.cn>
Subject: Re: [PATCH V2 1/1] netfilter/jump_label: HAVE_JUMP_LABEL instead of
 CONFIG_JUMP_LABEL
Message-ID: <20140825083857.GA10456@salvia>
References: <1408675215-2893-1-git-send-email-yizhouzhou@ict.ac.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408675215-2893-1-git-send-email-yizhouzhou@ict.ac.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2014 at 10:40:15AM +0800, Zhouyi Zhou wrote:
> Use HAVE_JUMP_LABEL as elsewhere in the kernel to ensure
> that the toolchain has the required support in addition to
> CONFIG_JUMP_LABEL being set.

Applied, thanks.

