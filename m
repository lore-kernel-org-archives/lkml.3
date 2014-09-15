Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557AbaIOOuA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 10:50:00 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:46572 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279AbaIOOt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 10:49:57 -0400
Message-ID: <1410792596.7106.166.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH 1/5] rhashtable: Remove gfp_flags from insert and remove
 functions
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Thomas Graf <tgraf@suug.ch>
Cc: davem@davemloft.net, paulmck@linux.vnet.ibm.com,
        john.r.fastabend@intel.com, kaber@trash.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 15 Sep 2014 07:49:56 -0700
In-Reply-To: <20140915124937.GB21541@casper.infradead.org>
References: <cover.1410782841.git.tgraf@suug.ch>
	 <bd3aa4282e89b022620225101ab491e344852f5f.1410782841.git.tgraf@suug.ch>
	 <1410784535.7106.164.camel@edumazet-glaptop2.roam.corp.google.com>
	 <20140915124937.GB21541@casper.infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-09-15 at 13:49 +0100, Thomas Graf wrote:

> Agreed. Will introduce this through a table parameter option when
> converting the inet hash table.

I am not sure you covered the /proc/net/tcp problem yet ? (or inet_diag)


