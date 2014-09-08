Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600AbaIHQY4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 12:24:56 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:47363 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753267AbaIHQYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 12:24:55 -0400
Date: Mon, 8 Sep 2014 17:24:49 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Daniel Thompson <daniel.thompson@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        patches@linaro.org, linaro-kernel@lists.linaro.org,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sumit Semwal <sumit.semwal@linaro.org>
Subject: Re: [PATCH v3 0/5] arm: Implement arch_trigger_all_cpu_backtrace
Message-ID: <20140908162449.GD12361@n2100.arm.linux.org.uk>
References: <1409931198-22600-1-git-send-email-daniel.thompson@linaro.org> <1410190115-32604-1-git-send-email-daniel.thompson@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410190115-32604-1-git-send-email-daniel.thompson@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2014 at 04:28:30PM +0100, Daniel Thompson wrote:
> * Restructured to sit nicely on a similar FYI patchset from Russell
>   King. It now effectively replaces the work in progress final patch
>   with something much more complete.

I'd suggest that patch 2 should be in a different place - get the FIQ
infrastructure in place first before adding any users of it would be
a much more sensible patch ordering.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
