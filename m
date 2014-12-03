Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857AbaLDGNQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 01:13:16 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:39295 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777AbaLDGNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 01:13:15 -0500
Date: Wed, 3 Dec 2014 01:21:56 -0800
From: Darren Hart <dvhart@infradead.org>
To: Azael Avalos <coproscefalo@gmail.com>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] toshiba_acpi: Change notify funtion to handle more
 events
Message-ID: <20141203092156.GE52608@vmdeb7>
References: <1417584992-2524-1-git-send-email-coproscefalo@gmail.com>
 <1417584992-2524-3-git-send-email-coproscefalo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417584992-2524-3-git-send-email-coproscefalo@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2014 at 10:36:32PM -0700, Azael Avalos wrote:
> Currently the function toshiba_acpi_notify only
> takes care of hotkeys, however, the TOSXXXX
> devices receive more events that can be useful.
> 
> This patch changes the function to be able to
> handle more events, and in the process, move all
> hotkey related code residing in it to a new
> function called toshiba_acpi_process_hotkeys,
> and also update the sysfs group whenever we
> receive a 0x92 event, which indicates a change
> in the keyboard backlight mode.

This would be better as two patches. One for process_hotkeys, and another for
the (smaller) kbd backlight sysfs update.

-- 
Darren Hart
Intel Open Source Technology Center
