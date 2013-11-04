Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987Ab3KDRUS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 12:20:18 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:55011 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751848Ab3KDRUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 12:20:16 -0500
Date: Mon, 4 Nov 2013 17:20:02 +0000
From: Will Deacon <will.deacon@arm.com>
To: Mark Salter <msalter@redhat.com>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm64: use generic RW_DATA_SECTION macro in linker script
Message-ID: <20131104172002.GG8595@mudshark.cambridge.arm.com>
References: <1381264659-11132-1-git-send-email-msalter@redhat.com>
 <20131009101447.GC5985@mudshark.cambridge.arm.com>
 <1381493921.8305.63.camel@deneb.redhat.com>
 <20131104112840.GC2527@arm.com>
 <1383583127.11574.29.camel@deneb.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383583127.11574.29.camel@deneb.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 04, 2013 at 04:38:47PM +0000, Mark Salter wrote:
> The .data section in the arm64 linker script currently lacks a
> definition for page-aligned data. This leads to a .page_aligned
> section being placed between the end of data and start of bss.
> This patch corrects that by using the generic RW_DATA_SECTION
> macro which includes support for page-aligned data.
> 
> Signed-off-by: Mark Salter <msalter@redhat.com>

  Acked-by: Will Deacon <will.deacon@arm.com>

Cheers Mark!

Will
