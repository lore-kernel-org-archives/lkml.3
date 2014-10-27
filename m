Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707AbaJ0NfU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 09:35:20 -0400
Received: from a.mx.secunet.com ([195.81.216.161]:57011 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752249AbaJ0NfS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 09:35:18 -0400
Date: Mon, 27 Oct 2014 14:35:10 +0100
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Fabian Frederick <fabf@skynet.be>
CC: <linux-kernel@vger.kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>
Subject: Re: [PATCH 1/1 net-next] xfrm: fix set but not used warning in
 xfrm_policy_queue_process()
Message-ID: <20141027133510.GA25142@secunet.com>
References: <1414250829-17908-1-git-send-email-fabf@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1414250829-17908-1-git-send-email-fabf@skynet.be>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [10.182.7.102]
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 25, 2014 at 05:27:09PM +0200, Fabian Frederick wrote:
> err was set but unused.
> 
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Applied to ipsec-next, thanks!
