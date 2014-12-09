Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416AbaLIWTp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 17:19:45 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:50788 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640AbaLIWTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 17:19:43 -0500
Date: Tue, 9 Dec 2014 14:19:31 -0800
From: Stephen Hemminger <stephen@networkplumber.org>
To: Alex Gartrell <agartrell@fb.com>
Cc: <jasonwang@redhat.com>, <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <mst@redhat.com>,
        <herbert@gondor.apena.org.au>, <kernel-team@fb.com>
Subject: Re: [RFC PATCH net-next] tun: support retrieving multiple packets
 in a single read with IFF_MULTI_READ
Message-ID: <20141209141931.68386652@urahara>
In-Reply-To: <1417752000-27171-1-git-send-email-agartrell@fb.com>
References: <1417752000-27171-1-git-send-email-agartrell@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Dec 2014 20:00:00 -0800
Alex Gartrell <agartrell@fb.com> wrote:

>  
> +static inline size_t tun_calc_max_put_len(const struct tun_struct *tun)
> +{
> +	size_t len = 0;

No need for inline with local static function. Let compiler decide.
