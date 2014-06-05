Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751873AbaFENre (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 09:47:34 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33170 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507AbaFENrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 09:47:33 -0400
Date: Thu, 5 Jun 2014 15:47:30 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Lan Tianyu <tianyu.lan@intel.com>
Cc: rjw@rjwysocki.net, lenb@kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH] Revert "ACPI / Battery: Remove battery's proc
 directory" and "ACPI: Remove CONFIG_ACPI_PROCFS_POWER and cm_sbsc.c"
Message-ID: <20140605134730.GA13859@amd.pavel.ucw.cz>
References: <1398872369-2755-1-git-send-email-tianyu.lan@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398872369-2755-1-git-send-email-tianyu.lan@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> The commit 1e2d9cd and 7d7ee95 remove ACPI Proc Battery
> directory and breaks some old userspace tools. This patch
> is to revert them.

Quick test shows that battery files are back in 3.15-rc8. Thanks!

								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
