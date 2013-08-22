Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753588Ab3HVPjL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 11:39:11 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:41947 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194Ab3HVPjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 11:39:07 -0400
Date: Thu, 22 Aug 2013 16:39:00 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: linux-acpi@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, mjg@redhat.com, rjw@sisk.pl,
        len.brown@intel.com, dtor@insightbb.com
Subject: Re: [PATCH 3/3] thinkpad_acpi: Wire unused micmute LED to capslock
Message-ID: <20130822153900.GA2878@srcf.ucam.org>
References: <1377180132-4933-1-git-send-email-Jason@zx2c4.com>
 <1377180132-4933-3-git-send-email-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377180132-4933-3-git-send-email-Jason@zx2c4.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 22, 2013 at 04:02:12PM +0200, Jason A. Donenfeld wrote:
> Thinkpads with a micmute LED do not have a capslock LED. The micmute LED
> is currently not used by any piece of Linux kernel land or user land. It
> seems reasonable to hook it up to caps lock, at least by default, so
> users can have some degree of functionality.

I think there's a risk of user confusion here, in that it's now possible 
for the mic mute light to be lit despite the internal microphone still 
being active. That seems like surprising behaviour.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
