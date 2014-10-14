Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932386AbaJNTPu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 15:15:50 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:43004 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755381AbaJNTPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 15:15:49 -0400
Date: Tue, 14 Oct 2014 12:15:42 -0700
From: Zach Brown <zab@zabbo.net>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org
Subject: Re: [RFC 1/1 linux-next] btrfs: don't opencode zero_user_segment
Message-ID: <20141014191542.GB6838@lenny.home.zabbo.net>
References: <1413308774-9985-1-git-send-email-fabf@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413308774-9985-1-git-send-email-fabf@skynet.be>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2014 at 07:46:14PM +0200, Fabian Frederick wrote:
> use function defined in include/linux/highmem.h
> Note that this reverts 2 last function call order

And adds a BUG_ON(PAGE_CACHE_SIZE > PAGE_SIZE).  We can take bets on
whether that will ever trigger.

- z
