Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360Ab3BEKUj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 05:20:39 -0500
Received: from www.linutronix.de ([62.245.132.108]:48383 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754151Ab3BEKUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 05:20:35 -0500
Date: Tue, 5 Feb 2013 11:20:33 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Leonid Shatz <leonid.shatz@ravellosystems.com>
cc: "'Izik Eidus'" <izik.eidus@ravellosystems.com>,
        linux-kernel@vger.kernel.org,
        "'Andrea Arcangeli'" <aarcange@redhat.com>,
        Mike Rapoport <mike.rapoport@ravellosystems.com>
Subject: RE: hrtimer possible issue
In-Reply-To: <030401ce02c9$e5139170$af3ab450$@ravellosystems.com>
Message-ID: <alpine.LFD.2.02.1302051119470.11905@ionos>
References: <510E58C2.9010207@ravellosystems.com> <alpine.LFD.2.02.1302041110160.11905@ionos> <030401ce02c9$e5139170$af3ab450$@ravellosystems.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Feb 2013, Leonid Shatz wrote:

> I assume the race can also happen between hrtimer cancel and start. In both
> cases timer base switch can happen.
> 
> Izik, please check if you can arrange the patch in the standard format (do
> we need to do it against latest kernel version?)

Yes please.

Thanks,

	tglx
