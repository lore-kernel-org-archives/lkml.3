Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974AbaA2VoU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 16:44:20 -0500
Received: from mga11.intel.com ([192.55.52.93]:48780 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942AbaA2VoT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 16:44:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,744,1384329600"; 
   d="scan'208";a="472882121"
Date: Wed, 29 Jan 2014 13:47:54 -0800
From: Bin Gao <bin.gao@linux.intel.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Bin Gao <bin.gao@intel.com>
Subject: Re: [PATCH v2] x86, tsc: Add missing Baytrail frequency to the table
Message-ID: <20140129214754.GA102071@bin.fm.intel.com>
References: <20140123150912.7ee822a0@alan.etchedpixels.co.uk>
 <1390553196-15346-1-git-send-email-mika.westerberg@linux.intel.com>
 <4460FA1017EA3844B646E90DA4E984057D5A4E9F@ORSMSX103.amr.corp.intel.com>
 <20140125090923.GA106810@bin.fm.intel.com>
 <20140127102002.GT18029@intel.com>
 <20140128120407.GB18029@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140128120407.GB18029@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 28, 2014 at 02:04:07PM +0200, Mika Westerberg wrote:
> Actually it does not work. I had the fallback path still in the patch when
> I tried.

Let's merge the ptach v2 then(continue on msr calibration retuning 0).
All supported SoCs now have the correct frequency ID coding
so continuing on non-PIC SoCs has very very small possibility.

