Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173AbaLGOGu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 09:06:50 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:48031 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752620AbaLGOGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 09:06:46 -0500
X-Sasl-enc: ZqZoYYfKjbWXVO7cz3kTKjwuU9/5V26AkUZOAK7Kp7x3 1417961205
Message-ID: <1417961203.17658.52.camel@localhost>
Subject: Re: Where exactly will arch_fast_hash be used
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: George Spelvin <linux@horizon.com>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, dborkman@redhat.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org, tgraf@suug.ch,
        tytso@mit.edu
Date: Sun, 07 Dec 2014 15:06:43 +0100
In-Reply-To: <20141207132305.24691.qmail@ns.horizon.com>
References: <20141207132305.24691.qmail@ns.horizon.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On So, 2014-12-07 at 08:23 -0500, George Spelvin wrote:
> So there are plenty of hash tables in Linux that you don't dare use this
> with.  In fact, so many that, as you rightly point out, it's not clear
> if it's worth providing this special optimization for the few remaining.

In case of openvswitch it shows a performance improvment. The seed
parameter could be used as an initial biasing of the crc32 function, but
in case of openvswitch it is only set to 0.

Bye,
Hannes


