Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750905AbaLOVJw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 16:09:52 -0500
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:57610 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbaLOVJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 16:09:51 -0500
Date: Mon, 15 Dec 2014 23:09:42 +0200
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Aleksey Makarov <feumilieu@gmail.com>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        David Daney <david.daney@cavium.com>,
        Aleksey Makarov <aleksey.makarov@auriga.com>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH 13/14] MIPS: OCTEON: Add register definitions for OCTEON
 III reset unit.
Message-ID: <20141215210942.GC10323@fuloong-minipc.musicnaut.iki.fi>
References: <1418666603-15159-1-git-send-email-aleksey.makarov@auriga.com>
 <1418666603-15159-14-git-send-email-aleksey.makarov@auriga.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418666603-15159-14-git-send-email-aleksey.makarov@auriga.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Dec 15, 2014 at 09:03:19PM +0300, Aleksey Makarov wrote:
> From: David Daney <david.daney@cavium.com>
> 
> Needed by follow-on patches.

Looks like only one of the unions was needed (cvmx_rst_boot)...?

A.
