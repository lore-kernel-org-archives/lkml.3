Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933528Ab3FRV2m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 17:28:42 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:50218 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932908Ab3FRV2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 17:28:40 -0400
Date: Tue, 18 Jun 2013 22:28:36 +0100
From: Jamie Iles <jamie@jamieiles.com>
To: David Daney <ddaney.cavm@gmail.com>
Cc: linux-mips@linux-mips.org, ralf@linux-mips.org,
        Jamie Iles <jamie@jamieiles.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
Subject: Re: [PATCH 0/5] MIPS/tty/8250: Use standard 8250 drivers for OCTEON
Message-ID: <20130618212836.GB3440@maple>
References: <1371582775-12141-1-git-send-email-ddaney.cavm@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371582775-12141-1-git-send-email-ddaney.cavm@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 12:12:50PM -0700, David Daney wrote:
> From: David Daney <david.daney@cavium.com>
> 
> Get rid of the custom OCTEON UART probe code and use 8250_dw instead.
> 
> The first patch just gets rid of Ralf's Kconfig workarounds for the
> real problem, which is OCTEON's inclomplete serial support.
> 
> Then we just make minor patches to 8250_dw, and rip out all this
> OCTEON code.
> 
> Since the patches are all interdependent, we might want to merge them
> via a single tree (perhaps Ralf's MIPS tree).

Looks good!

Reviewed-by: Jamie Iles <jamie@jamieiles.com>

for the series.

Thanks,

Jamie
