Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759190AbaJaUd4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 16:33:56 -0400
Received: from www.linutronix.de ([62.245.132.108]:45563 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757268AbaJaUdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 16:33:55 -0400
Date: Fri, 31 Oct 2014 21:33:44 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dave Hansen <dave.hansen@intel.com>
cc: "Ren, Qiaowei" <qiaowei.ren@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>
Subject: Re: [PATCH v9 09/12] x86, mpx: decode MPX instruction to get bound
 violation information
In-Reply-To: <5453EE0E.8060200@intel.com>
Message-ID: <alpine.DEB.2.11.1410312133120.5308@nanos>
References: <1413088915-13428-1-git-send-email-qiaowei.ren@intel.com> <1413088915-13428-10-git-send-email-qiaowei.ren@intel.com> <alpine.DEB.2.11.1410241408360.5308@nanos> <9E0BE1322F2F2246BD820DA9FC397ADE0180ED16@shsmsx102.ccr.corp.intel.com>
 <alpine.DEB.2.11.1410272135420.5308@nanos> <5453EE0E.8060200@intel.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Oct 2014, Dave Hansen wrote:

> On 10/27/2014 01:36 PM, Thomas Gleixner wrote:
> > You're repeating yourself. Care to read the discussion about this from
> > the last round of review again?
> 
> OK, so here's a rewritten decoder.  I think it's a lot more robust and
> probably fixes a bug or two.  This ends up saving ~70 lines of code out
> of ~300 or so for the old patch.
> 
> I'll include this in the next series, but I'm posting it early and often
> to make sure I'm on the right track.

Had a short glance. This looks really very well done!

Thanks,

	tglx
