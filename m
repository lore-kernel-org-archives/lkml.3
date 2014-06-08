Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932933AbaFHUC5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2014 16:02:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11493 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932935AbaFHUCs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2014 16:02:48 -0400
Message-ID: <5394C15D.3020507@redhat.com>
Date: Sun, 08 Jun 2014 22:02:37 +0200
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Hannes Frederic Sowa <hannes@stressinduktion.org>
CC: George Spelvin <linux@horizon.com>, davem@davemloft.net,
        shemminger@osdl.org, tytso@mit.edu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] lib/random32.c: Make prandom_u32_max efficient for
 powers of 2
References: <20140607082805.10120.qmail@ns.horizon.com> <1402248852.14095.126480525.5C81F8C6@webmail.messagingengine.com>
In-Reply-To: <1402248852.14095.126480525.5C81F8C6@webmail.messagingengine.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08/2014 07:34 PM, Hannes Frederic Sowa wrote:
...
> Please check this as it makes the code more complicated and I doubt it is worth it.

Agreed.
