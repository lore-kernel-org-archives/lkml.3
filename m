Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820Ab3D3GeS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 02:34:18 -0400
Received: from merlin.infradead.org ([205.233.59.134]:58476 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752965Ab3D3GeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 02:34:16 -0400
Date: Tue, 30 Apr 2013 08:34:01 +0200
From: Jens Axboe <axboe@kernel.dk>
To: Philippe De Muyter <phdm@macqel.be>
Cc: linux-kernel@vger.kernel.org, Matt Domsch <Matt_Domsch@dell.com>,
        Panagiotis Issaris <takis@issaris.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] partitions/efi.c: replace useless kzalloc's by kmalloc's
Message-ID: <20130430063401.GJ9563@kernel.dk>
References: <1367269218-17056-1-git-send-email-phdm@macqel.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367269218-17056-1-git-send-email-phdm@macqel.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 29 2013, Philippe De Muyter wrote:
> In alloc_read_gpt_entries and alloc_read_gpt_header, the kzalloc'ated
> zones are either totally overwritten by the following read_lba call,
> or freed.  As kmalloc is cheaper than kzalloc, use kmalloc.

Applied, thanks.

-- 
Jens Axboe

