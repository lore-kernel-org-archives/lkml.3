Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933639AbaLEDcH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 22:32:07 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:43270 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932098AbaLEDcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 22:32:04 -0500
Date: Wed, 3 Dec 2014 05:38:33 -0800
From: Darren Hart <dvhart@infradead.org>
To: Azael Avalos <coproscefalo@gmail.com>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/3] toshiba_acpi: Hotkeys and event handling changes
Message-ID: <20141203133833.GH75099@vmdeb7>
References: <1417749767-3898-1-git-send-email-coproscefalo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417749767-3898-1-git-send-email-coproscefalo@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2014 at 08:22:44PM -0700, Azael Avalos wrote:
> These patches change the current code to accomodate the handling
> of more events, since so far, it only handles hotkey events (0x80),
> move the hotkey enabling code to a sub function to avoid duplication,
> and add event 0x92 which indicates a change in the keyboard backlight
> mode.
> 
> Changes since V3:
> - Removed a left over variable from the split in patch 02 and
>   moved it to patch 03 (where it belongs)
> - A bit more verbose description on patch 03
> 
> Azael Avalos (3):
>   toshiba_acpi: Move hotkey enabling code to own function
>   toshiba_acpi: Change notify funtion to handle more events
>   toshiba_acpi: Add keyboard backlight mode change event

Queued. Your 1/3 commit message reverted to the short line length, might want to
update your tools. ;-) I took care of it.

Thanks Azael,

-- 
Darren Hart
Intel Open Source Technology Center
