Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268AbbAMP4M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 10:56:12 -0500
Received: from casper.infradead.org ([85.118.1.10]:52965 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544AbbAMP4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 10:56:10 -0500
Date: Tue, 13 Jan 2015 15:56:05 +0000
From: "'Thomas Graf'" <tgraf@suug.ch>
To: David Laight <David.Laight@ACULAB.COM>
Cc: "davem@davemloft.net" <davem@davemloft.net>,
        Fengguang Wu <fengguang.wu@intel.com>, LKP <lkp@01.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "coreteam@netfilter.org" <coreteam@netfilter.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] rhashtable: Lower/upper bucket may map to same
 lock while shrinking
Message-ID: <20150113155605.GN20387@casper.infradead.org>
References: <20150112232217.GA5277@wfg-t540p.sh.intel.com>
 <20150112235821.GB16617@casper.infradead.org>
 <063D6719AE5E284EB5DD2968C1650D6D1CAC6593@AcuExch.aculab.com>
 <20150113112507.GH20387@casper.infradead.org>
 <063D6719AE5E284EB5DD2968C1650D6D1CAC6969@AcuExch.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D1CAC6969@AcuExch.aculab.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <tgraf@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/15 at 03:06pm, David Laight wrote:
> OK, ht->mutes saves the day.
> Might be worth a comment to save people looking at the code in isolation
> from worrying and doing a bit search.
> OTOH it might be obvious from a slightly larger fragment than the diff.

Good idea. Will do this. Also, thanks for the suggestion in the other
email. I now understand what you meant.
