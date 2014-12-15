Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750911AbaLOWID (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 17:08:03 -0500
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:58486 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745AbaLOWIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 17:08:01 -0500
Date: Tue, 16 Dec 2014 00:07:52 +0200
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: David Daney <ddaney@caviumnetworks.com>
Cc: Aleksey Makarov <feumilieu@gmail.com>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>,
        Aleksey Makarov <aleksey.makarov@auriga.com>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH 13/14] MIPS: OCTEON: Add register definitions for OCTEON
 III reset unit.
Message-ID: <20141215220752.GF10323@fuloong-minipc.musicnaut.iki.fi>
References: <1418666603-15159-1-git-send-email-aleksey.makarov@auriga.com>
 <1418666603-15159-14-git-send-email-aleksey.makarov@auriga.com>
 <20141215210942.GC10323@fuloong-minipc.musicnaut.iki.fi>
 <548F5330.6090508@caviumnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <548F5330.6090508@caviumnetworks.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Dec 15, 2014 at 01:31:28PM -0800, David Daney wrote:
> On 12/15/2014 01:09 PM, Aaro Koskinen wrote:
> >Hi,
> >
> >On Mon, Dec 15, 2014 at 09:03:19PM +0300, Aleksey Makarov wrote:
> >>From: David Daney <david.daney@cavium.com>
> >>
> >>Needed by follow-on patches.
> >
> >Looks like only one of the unions was needed (cvmx_rst_boot)...?
> 
> This follows the form of the other register definition files.
> 
> If Ralf requests it, we would consider deleting some of the currently unused
> definitions.

Most of this stuff looks like machine generated. Can you at least
just make it to minimize the amount of C code it produces?
What's the point of having union definitions like e.g. these:

	+	struct cvmx_rst_boot_s                cn70xx;
	+	struct cvmx_rst_boot_s                cn70xxp1;
	+	struct cvmx_rst_boot_s                cn73xx;
	+	struct cvmx_rst_boot_s                cn78xx;

etc?

A.
