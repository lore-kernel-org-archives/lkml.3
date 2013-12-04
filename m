Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251Ab3LDJIY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 04:08:24 -0500
Received: from mail-bk0-f44.google.com ([209.85.214.44]:51794 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754204Ab3LDJIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 04:08:18 -0500
Date: Wed, 4 Dec 2013 10:08:14 +0100
From: Ingo Molnar <mingo@kernel.org>
To: ville.syrjala@linux.intel.com
Cc: intel-gfx@lists.freedesktop.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/6] x86: Add Intel graphics stolen memory quirk for
 gen2 platforms
Message-ID: <20131204090814.GA32218@gmail.com>
References: <1386085793-317-1-git-send-email-ville.syrjala@linux.intel.com>
 <1386085793-317-3-git-send-email-ville.syrjala@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386085793-317-3-git-send-email-ville.syrjala@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* ville.syrjala@linux.intel.com <ville.syrjala@linux.intel.com> wrote:

> v2: Rewrite to use the TOM-TSEG_SIZE-stolen_size and TOUD methods

I guess v2 is a reaction to my review feedback? I got no reply to my 
mail from you so I'm not sure and I'd like to know whether all 
feedback was addressed.

Thanks,

	Ingo
