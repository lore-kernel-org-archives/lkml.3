Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757295Ab3EOIPt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 04:15:49 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55184 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756609Ab3EOIPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 04:15:47 -0400
Date: Wed, 15 May 2013 10:15:01 +0200
From: Jens Axboe <axboe@kernel.dk>
To: Asai Thambi S P <asamymuthupa@micron.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sam Bradshaw <sbradshaw@micron.com>
Subject: Re: [PATCH] mtip32xx: Add SRSI support
Message-ID: <20130515081448.GG3276@kernel.dk>
References: <518BE87F.3080201@micron.com>
 <518D48BA.6010507@micron.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <518D48BA.6010507@micron.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 11 2013, Asai Thambi S P wrote:
> On 5/9/2013 11:48 PM, Asai Thambi S P wrote:
> 
> > 
> > This patch add support for SRSI(Surprise Removal Surprise Insertion).
> 
> Jens,
> 
> Forgot to include. This patch is for 3.10

It's a big patch for 3.10 when submitted after the merge window... I'd
feel a lot better slurping it up for 3.11, to be honest.

-- 
Jens Axboe

