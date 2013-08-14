Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932766Ab3HNKjb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 06:39:31 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41480 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932695Ab3HNKj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 06:39:29 -0400
Date: Wed, 14 Aug 2013 11:38:46 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: linux-arm-kernel@lists.infradead.org
Cc: Jens Axboe <axboe@kernel.dk>, Nicolas Pitre <nicolas.pitre@linaro.org>,
        linux-scsi@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        Chris Ball <cjb@laptop.org>
Subject: Re: [PATCH RFC 00/51] Preview of DMA mask changes
Message-ID: <20130814103845.GO23006@n2100.arm.linux.org.uk>
References: <20130801213420.GL23006@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130801213420.GL23006@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 01, 2013 at 10:34:20PM +0100, Russell King - ARM Linux wrote:
> So, this patch set is a preview of the DMA mask changes which I currently
> have in my tree.

Looking at the comments which this patch set has received, I see very
little in the way of feedback.  So I think it's time to move to the
next stage.  I will be re-posting these with a [PATCH] tag, with the
appropriate CC's, and putting them into linux-next a few days after
assuming no objections to them are forthcoming.
