Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757373Ab3HGJRd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 05:17:33 -0400
Received: from mail.us.es ([193.147.175.20]:56521 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756689Ab3HGJRb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 05:17:31 -0400
X-Qmail-Scanner-Diagnostics: from 127.0.0.1 by antivirus2 (envelope-from <pneira@us.es>, uid 501) with qmail-scanner-2.10 
 (clamdscan: 0.97.8/17637. spamassassin: 3.3.2.  
 Clear:RC:1(127.0.0.1):SA:0(-97.8/7.5):. 
 Processed in 1.645487 secs); 07 Aug 2013 09:17:28 -0000
X-Envelope-From: pneira@us.es
Date: Wed, 7 Aug 2013 11:17:22 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Rui Xiang <rui.xiang@huawei.com>
Cc: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        serge.hallyn@ubuntu.com, ebiederm@xmission.com,
        akpm@linux-foundation.org, gaofeng@cn.fujitsu.com,
        guz.fnst@cn.fujitsu.com, libo.chen@huawei.com
Subject: Re: [PATCH v3 11/11] netfilter: use ns_printk in iptable context
Message-ID: <20130807091722.GA9470@localhost>
References: <1375861035-24320-1-git-send-email-rui.xiang@huawei.com>
 <1375861035-24320-12-git-send-email-rui.xiang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375861035-24320-12-git-send-email-rui.xiang@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Aug 07, 2013 at 03:37:15PM +0800, Rui Xiang wrote:
> To containerise iptables log, use ns_printk
> to report individual logs to container as
> getting syslog_ns from net->user_ns.

This patch is missing the removal of a couple of LOC at the very
beginning of ipt_log_packet and ip6t_log_packet to get this working.

Please, revamp it. Thanks.
