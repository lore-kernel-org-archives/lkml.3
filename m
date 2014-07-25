Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760511AbaGYNB3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 09:01:29 -0400
Received: from mail.us.es ([193.147.175.20]:58806 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760493AbaGYNB1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 09:01:27 -0400
X-Qmail-Scanner-Diagnostics: from 127.0.0.1 by antivirus1 (envelope-from <pneira@us.es>, uid 501) with qmail-scanner-2.10 
 (clamdscan: 0.98.4/19221. spamassassin: 3.3.2.  
 Clear:RC:1(127.0.0.1):SA:0(-100.2/7.5):. 
 Processed in 5.758061 secs); 25 Jul 2014 13:01:26 -0000
X-Spam-ASN: AS42863 89.214.0.0/16
X-Envelope-From: pneira@us.es
Date: Fri, 25 Jul 2014 15:01:34 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: "David S. Miller" <davem@davemloft.net>, Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [linux-next] netfilter: kill remnants of ulog targets
Message-ID: <20140725130134.GC13940@salvia>
References: <1406107694.12441.8.camel@x220>
 <20140723093949.GA3754@salvia>
 <1406291131.8231.20.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406291131.8231.20.camel@x220>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2014 at 02:25:31PM +0200, Paul Bolle wrote:
> The ulog targets were recently killed. A few references to the Kconfig
> macros CONFIG_IP_NF_TARGET_ULOG and CONFIG_BRIDGE_EBT_ULOG were left
> untouched. Kill these too.

Those were my fault, applied, thanks Paul.
