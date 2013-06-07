Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757062Ab3FGSQy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 14:16:54 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:40854 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756759Ab3FGSQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 14:16:53 -0400
Subject: Re: [PATCH][RESEND] Silence noisy per-device cciss messages
From: "Mike Miller (OS Dev)" <mike.miller@hp.com>
Reply-To: mike.miller@hp.com, mikem@beardog.cce.hp.com
To: "Bryn M. Reeves" <bmr@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, scameron@beardog.cce.hp.com,
        thenzl@redhat.com, axboe@kernel.dk
In-Reply-To: <51B1DD18.3080104@redhat.com>
References: <51B1DD18.3080104@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 Jun 2013 13:16:50 -0500
Message-ID: <1370629010.19747.276.camel@thumper.usa.hp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-30.el6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-06-07 at 14:16 +0100, Bryn M. Reeves wrote:
> Currently cciss logs a message each time cciss_read_capacity_16 is called:
> 
> kernel: cciss 0000:03:00.0:       blocks= 5274326576 block_size= 512
> 
> This generates considerable log noise. An identical message was deleted 
> from cciss_read_capacity in 2009.
> 
> This patch mirrors the change made to cciss_read_capacity in commit
> 983333c. Emitting device and block size information at KERN_INFO on
> each read_capacity() leads to a lot of log noise.
> 
> Signed-off-by: Bryn M. Reeves <bmr@redhat.com>

Acked-by: Mike Miller <mike.miller@hp.com>

