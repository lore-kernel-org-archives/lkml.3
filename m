Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313AbaIIAMN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 20:12:13 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:50969 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753253AbaIIAML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 20:12:11 -0400
Date: Mon, 8 Sep 2014 17:12:08 -0700
From: Darren Hart <dvhart@infradead.org>
To: Azael Avalos <coproscefalo@gmail.com>
Cc: Matthew Garrett <matthew.garrett@nebula.com>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] toshiba_acpi: Additional hotkey scancodes
Message-ID: <20140909001207.GE5835@vmdeb7>
References: <1409937247-2525-1-git-send-email-coproscefalo@gmail.com>
 <1409937247-2525-2-git-send-email-coproscefalo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409937247-2525-2-git-send-email-coproscefalo@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 05, 2014 at 11:14:03AM -0600, Azael Avalos wrote:
> Appart from reporting hotkeys, the INFO method is used
> as a system wide event notifier for hardware or
> software changes.
> 
> This patch adds additional "events" to the keymap list,
> ignored by now, until we find them a good use.
> 
> Signed-off-by: Azael Avalos <coproscefalo@gmail.com>

Queued, thanks.

-- 
Darren Hart
Intel Open Source Technology Center
