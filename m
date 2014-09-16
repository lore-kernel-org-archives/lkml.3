Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450AbaIPSyv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 14:54:51 -0400
Received: from casper.infradead.org ([85.118.1.10]:54603 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755154AbaIPSys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 14:54:48 -0400
Date: Tue, 16 Sep 2014 19:54:47 +0100
From: Thomas Graf <tgraf@suug.ch>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH 1/1] lib: rhashtable: remove second linux/log2.h inclusion
Message-ID: <20140916185447.GA29810@casper.infradead.org>
References: <1410890658-31144-1-git-send-email-fabf@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410890658-31144-1-git-send-email-fabf@skynet.be>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <tgraf@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16/14 at 08:04pm, Fabian Frederick wrote:
> linux/log2.h was included twice.
> 
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Acked-by: Thomas Graf <tgraf@suug.ch>
