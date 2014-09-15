Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488AbaIOIqa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 04:46:30 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:56866 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753311AbaIOIq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 04:46:28 -0400
Date: Mon, 15 Sep 2014 09:46:16 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
Cc: "'Will Deacon'" <will.deacon@arm.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        "'linux-mm@kvack.org'" <linux-mm@kvack.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Subject: Re: [RFC] arm:extend the reserved mrmory for initrd to be page
	aligned
Message-ID: <20140915084616.GX12361@n2100.arm.linux.org.uk>
References: <35FD53F367049845BC99AC72306C23D103D6DB4915FC@CNBJMBX05.corpusers.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35FD53F367049845BC99AC72306C23D103D6DB4915FC@CNBJMBX05.corpusers.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2014 at 01:11:14PM +0800, Wang, Yalin wrote:
> this patch extend the start and end address of initrd to be page aligned,
> so that we can free all memory including the un-page aligned head or tail
> page of initrd, if the start or end address of initrd are not page
> aligned, the page can't be freed by free_initrd_mem() function.

Have you tested this patch?  If so, how thorough was your testing?

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
