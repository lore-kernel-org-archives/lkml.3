Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811AbaKVWIH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 17:08:07 -0500
Received: from zimbra13.linbit.com ([212.69.166.240]:53319 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778AbaKVWIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 17:08:05 -0500
Date: Sat, 22 Nov 2014 23:08:01 +0100
From: Lars Ellenberg <lars.ellenberg@linbit.com>
To: drbd-user@lists.linbit.com, drbd-dev@lists.linbit.com,
        linux-kernel@vger.kernel.org
Subject: Re: [DRBD-user] FIX MEs for spinlocks in drbd_worker.c
Message-ID: <20141122220801.GX307@soda.linbit>
Mail-Followup-To: drbd-user@lists.linbit.com, drbd-dev@lists.linbit.com,
	linux-kernel@vger.kernel.org
References: <546E6D1F.9070300@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <546E6D1F.9070300@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2014 at 05:37:19PM -0500, nick wrote:
> Greetings Lars,
> I am wondering about removing the spin locks around the linked list
> operators in worker.c or do we need to test it first it first on
> actual hardware.
> Cheers Nick

Unless you have deep insight in the inner workings of DRBD
and their interactions, I'd strongly recommend to go find
some other fixmes.

That is much more complicated than just removing those lines and hope
for the best. Otherwise they would not be there (and not FIXME tag to
find them).

Maybe you just want to reverse-sort your grep for fixmes,
so that the bottom of the list gets some love, too.

Thanks,
	Lars

