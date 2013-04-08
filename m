Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965199Ab3DHOrN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 10:47:13 -0400
Received: from mga01.intel.com ([192.55.52.88]:23791 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965181Ab3DHOrM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 10:47:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,432,1363158000"; 
   d="scan'208";a="315989816"
Date: Mon, 8 Apr 2013 16:47:10 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Jean-Nicolas GRAUX <jean-nicolas.graux@stericsson.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH] mfd: support stmpe1801 18 bits enhanced port expander
Message-ID: <20130408144710.GS24058@zurbaran>
References: <1361206222-2341-1-git-send-email-jean-nicolas.graux@stericsson.com>
 <20130408095601.GP24058@zurbaran>
 <51629622.3040509@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51629622.3040509@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean-Nicolas,

On Mon, Apr 08, 2013 at 12:04:18PM +0200, Jean-Nicolas GRAUX wrote:
> On 04/08/2013 11:56 AM, Samuel Ortiz wrote:
> >Hi Jean-Nicolas,
> >
> >On Mon, Feb 18, 2013 at 05:50:22PM +0100, Jean-Nicolas Graux wrote:
> >>Provides support for 1801 variant of stmpe gpio port expanders.
> >>This chip has 18 gpios configurable as GPI, GPO, keypad matrix,
> >>special key or dedicated key function.
> >>
> >>Note that special/dedicated key function is not supported yet.
> >>
> >>Change-Id: I6ea89af7b96e9a02478ebec3467291e7d7c510c9
> >No Change-Id, please.
> >
> >>Signed-off-by: Jean-Nicolas Graux <jean-nicolas.graux@stericsson.com>
> >>---
> >>  drivers/gpio/gpio-stmpe.c             |   52 +++++--
> >>  drivers/input/keyboard/stmpe-keypad.c |  267 ++++++++++++++++++++++++++-------
> >>  drivers/mfd/Kconfig                   |    1 +
> >>  drivers/mfd/stmpe-i2c.c               |    1 +
> >>  drivers/mfd/stmpe.c                   |   97 +++++++++++-
> >>  drivers/mfd/stmpe.h                   |   49 ++++++
> >>  include/linux/mfd/stmpe.h             |    3 +
> >>  7 files changed, 398 insertions(+), 72 deletions(-)
> >This should be splitted into 3 patches, an mfd one and then an input and a
> >gpio one. I would carry all 3 of them through the MFD tree on order to handle
> >build dependencies.
> >
> >Cheers,
> >Samuel.
> >
> Hello Samuel,
> Ok, i do the split. I guess i should also rebase on latest 3.9 kernel.
Or against mfd-next
(git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-next.git).

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
