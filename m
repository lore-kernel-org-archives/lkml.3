Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498AbaGUUyN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 16:54:13 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:46987 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754432AbaGUUyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 16:54:12 -0400
Date: Mon, 21 Jul 2014 21:53:55 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Richard Weinberger <richard@nod.at>
Cc: tony.luck@intel.com, fenghua.yu@intel.com,
        linux-arm-kernel@lists.infradead.org, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] arm: Remove RISC OS personality
Message-ID: <20140721205355.GH21766@n2100.arm.linux.org.uk>
References: <1405263538-27589-1-git-send-email-richard@nod.at> <1405263538-27589-2-git-send-email-richard@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405263538-27589-2-git-send-email-richard@nod.at>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 13, 2014 at 04:58:57PM +0200, Richard Weinberger wrote:
> The RISC OS personality seems to be unused and untested for a long time.
> Let's rip it out.
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>

Thanks.

Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
