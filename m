Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932925Ab3HGM7E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 08:59:04 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40676 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932738Ab3HGM7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 08:59:03 -0400
Date: Wed, 7 Aug 2013 13:55:08 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mathias Krause <minipli@googlemail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: fix typo in is_gate_vma() macro
Message-ID: <20130807125508.GG23006@n2100.arm.linux.org.uk>
References: <1375824875-1934-1-git-send-email-minipli@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375824875-1934-1-git-send-email-minipli@googlemail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 06, 2013 at 11:34:35PM +0200, Mathias Krause wrote:
> Commit a5463cd3 "ARM: make vectors page inaccessible from userspace"
> introduced a typo making arch_vma_name() always return "[vectors]".
> Fix up that regression (of the hush-hush security fix).

And if you search the list archives, you will see that I've already
replied to patches exactly like this many times so far.  Thanks.
