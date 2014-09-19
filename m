Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757653AbaISRZp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 13:25:45 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:48212 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756107AbaISRZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 13:25:44 -0400
Date: Fri, 19 Sep 2014 10:25:38 -0700
From: Darren Hart <dvhart@infradead.org>
To: Frans Klaver <fransklaver@gmail.com>
Cc: Corentin Chary <corentin.chary@gmail.com>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/9] eeepc cleanup
Message-ID: <20140919172538.GC34042@vmdeb7>
References: <1410990447-3210-1-git-send-email-fransklaver@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410990447-3210-1-git-send-email-fransklaver@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2014 at 11:47:18PM +0200, Frans Klaver wrote:
> Here's the second installment cleaning up some things in the eeepc laptop
> driver.
> 
> This depends on "eeepc-laptop: simplify parse_arg()".
> 
> For those interested, I keep a copy based on Darren's testing branch on
> github:

Please note, "testing" is strictly for use with Fengguang's 0day robot. It
*will* rebase and be recreated willy nilly.

If you want to base on something I've queued, I suggest the "for-next" branch as
I expect that to be far more stable. Rabses should be *very* rare there.

Feel free to use "testing" if you need to, just be aware it will rebase.

> 
> 	https://github.com/fransklaver/linux.git tags/eeepc_cleanup_v2

Queued for testing.

Thanks Frans!

-- 
Darren Hart
Intel Open Source Technology Center
