Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757043Ab3EBKUZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 06:20:25 -0400
Received: from canardo.mork.no ([148.122.252.1]:33977 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756652Ab3EBKUU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 06:20:20 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: David Miller <davem@davemloft.net>
Cc: kaber@trash.net, torvalds@linux-foundation.org, hayeswang@realtek.com,
        akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bhutchings@solarflare.com
Subject: Re: [GIT] Networking
Organization: m
References: <20130502.041625.412316202038784117.davem@davemloft.net>
	<20130502083619.GA22010@macbook.localnet>
	<87d2t9bvj1.fsf@nemi.mork.no>
	<20130502.051727.949429506738234701.davem@davemloft.net>
Date: Thu, 02 May 2013 12:19:59 +0200
In-Reply-To: <20130502.051727.949429506738234701.davem@davemloft.net> (David
	Miller's message of "Thu, 02 May 2013 05:17:27 -0400 (EDT)")
Message-ID: <878v3xbs4w.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> writes:
> From: Bjørn Mork <bjorn@mork.no>
> Date: Thu, 02 May 2013 11:06:42 +0200
>
>> Adding the new netdev features will make it go from 1 to 2:
>
> We already had more than 31 feature bits before Patrick's
> changes, and I'm pretty sure this was the case when we added
> that ethtool API.

Oh, thanks.  Then I misunderstood the issue.  This is one case where I'm
happy to be wrong :)


Bjørn
