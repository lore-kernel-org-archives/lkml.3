Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754381AbaHKRm1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 13:42:27 -0400
Received: from qmta07.emeryville.ca.mail.comcast.net ([76.96.30.64]:44421 "EHLO
	qmta07.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751874AbaHKRm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 13:42:26 -0400
Date: Mon, 11 Aug 2014 12:42:24 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Fengguang Wu <fengguang.wu@intel.com>
cc: LKML <linux-kernel@vger.kernel.org>, "lkp@01.org" <lkp@01.org>
Subject: Re: [percpu] BUG: unable to handle kernel paging request at
 000000000000de40
In-Reply-To: <20140811132213.GA7713@localhost>
Message-ID: <alpine.DEB.2.11.1408111241060.14298@gentwo.org>
References: <20140811132213.GA7713@localhost>
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII
Content-ID: <alpine.DEB.2.11.1408111241062.14298@gentwo.org>
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Aug 2014, Fengguang Wu wrote:

> This kernel oops happens on a Nehalem-EX machine and is related to
> some commit in the percpu branch(*). I'm not able to bisect it down
> because the machine failed to reboot itself on this oops..

Ok I pushed a fix into the percpu branch. The build should have shown an
issue of a pointer mismatch in __x2apic_send_IPI_mask.
