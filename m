Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272Ab3IWFy1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 01:54:27 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:49025 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544Ab3IWFy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 01:54:26 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <20130923131658.ef9c825e013ed36de2047044@canb.auug.org.au>
References: <20130923131658.ef9c825e013ed36de2047044@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: linux-next: manual merge of the staging tree with the staging.current tree
From: Jonathan Cameron <jic23@kernel.org>
Date: Mon, 23 Sep 2013 06:54:22 +0100
To: Stephen Rothwell <sfr@canb.auug.org.au>, Greg KH <greg@kroah.com>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Lars-Peter Clausen <lars@metafoo.de>
Message-ID: <0636907b-8117-4501-a6b5-ab485e928145@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>Hi Greg,
>
>Today's linux-next merge of the staging tree got a conflict in
>drivers/iio/industrialio-buffer.c between commit d66e0452bf6b ("iio:
>Fix
>crash when scan_bytes is computed with active_scan_mask == NUL") from
>the
>staging.current tree and commit 705ee2c98a37 ("iio:buffer: Simplify
>iio_buffer_is_active()") from the staging tree.
>
>I fixed it up (see below) and can carry the fix as necessary (no action
>is required).

Thanks Stephen.

The merge is correct.

Jonathan

-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.
