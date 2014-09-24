Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641AbaIXKUb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 06:20:31 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:36478 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753858AbaIXKU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 06:20:28 -0400
Date: Wed, 24 Sep 2014 12:20:16 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Sudeep Holla <sudeep.holla@arm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>, x86@kernel.org,
        linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH v4 01/11 UPDATE] cpumask: factor out show_cpumap into
 separate helper function
Message-ID: <20140924102016.GW16043@twins.programming.kicks-ass.net>
References: <1409763617-17074-2-git-send-email-sudeep.holla@arm.com>
 <1409845592-27739-1-git-send-email-sudeep.holla@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409845592-27739-1-git-send-email-sudeep.holla@arm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2014 at 04:46:32PM +0100, Sudeep Holla wrote:
> From: Sudeep Holla <sudeep.holla@arm.com>
> 
> Many sysfs *_show function use cpu{list,mask}_scnprintf to copy cpumap
> to the buffer aligned to PAGE_SIZE, append '\n' and '\0' to return null
> terminated buffer with newline.
> 
> This patch creates a new helper function cpumap_print_to_pagebuf in
> cpumask.h using newly added bitmap_print_to_pagebuf and consolidates
> most of those sysfs functions using the new helper function.
> 
> Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
> Suggested-by: Stephen Boyd <sboyd@codeaurora.org>
> Acked-by: "Rafael J. Wysocki" <rjw@rjwysocki.net>
> Acked-by: Bjorn Helgaas <bhelgaas@google.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
