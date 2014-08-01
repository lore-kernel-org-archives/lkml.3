Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869AbaHAKd1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 06:33:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:51738 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753497AbaHAKdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 06:33:25 -0400
Date: Fri, 1 Aug 2014 11:33:24 +0100
From: Thomas Graf <tgraf@suug.ch>
To: Nikolay Aleksandrov <nikolay@redhat.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kaber@trash.net, paulmck@linux.vnet.ibm.com, josh@joshtriplett.org,
        challa@noironetworks.com, walpole@cs.pdx.edu, dev@openvswitch.org,
        tklauser@distanz.ch, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net-next 1/3] lib: Resizable, Scalable, Concurrent Hash
 Table
Message-ID: <20140801103324.GB7331@casper.infradead.org>
References: <cover.1406882738.git.tgraf@suug.ch>
 <15a766adefc269dd26001474e9b67dbbd0d5bc82.1406882738.git.tgraf@suug.ch>
 <53DB656C.9000907@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53DB656C.9000907@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <tgraf@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/14 at 12:01pm, Nikolay Aleksandrov wrote:
> I see that ht->shift is being set but then ht is being zeroed, wouldn't this
> allow for the table to double ilog2(tbl->size) times more ?

Absolutely, thanks for catching this!
