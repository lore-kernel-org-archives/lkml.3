Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759064Ab3BYPEO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 10:04:14 -0500
Received: from zabrina.hetzner-de.towertech.it ([178.63.16.19]:41700 "EHLO
	zabrina.hetzner-de.towertech.it" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751148Ab3BYPEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 10:04:12 -0500
Date: Mon, 25 Feb 2013 16:04:09 +0100
From: Alessandro Zummo <a.zummo@towertech.it>
To: Prarit Bhargava <prarit@redhat.com>
Cc: John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Matt Fleming <matt.fleming@intel.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>, linux-efi@vger.kernel.org
Subject: Re: [RFE PATCH 1/2] x86, rtc, ntp, Do full rtc synchronization with
 ntp
Message-ID: <20130225160409.6ec6ec57@linux.lan.towertech.it>
In-Reply-To: <512A4A19.2090800@redhat.com>
References: <1360861375-24131-1-git-send-email-prarit@redhat.com>
	<1360861375-24131-2-git-send-email-prarit@redhat.com>
	<5127D853.6030703@linaro.org>
	<512A4A19.2090800@redhat.com>
Organization: Tower Technologies
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Feb 2013 12:12:57 -0500
Prarit Bhargava <prarit@redhat.com> wrote:

> Given the test results I think this should go in earlier rather than later;  I'd
> like to target 3.10 for the full sync, and possibly 3.11 for the HCTOSYS stuff.
> 
> ... unless anyone has a strenuous objection ;)

 looks reasonable.

 I prefer == 0 instead of !rtc_valid_tm(&tm),
 but it's just a cosmetic issue.

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

