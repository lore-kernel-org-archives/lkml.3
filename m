Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936AbaLDGN4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 01:13:56 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:39592 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777AbaLDGNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 01:13:55 -0500
Date: Wed, 3 Dec 2014 01:22:38 -0800
From: Darren Hart <dvhart@infradead.org>
To: Azael Avalos <coproscefalo@gmail.com>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] toshiba_acpi: Move hotkey enabling code to own
 function
Message-ID: <20141203092237.GF52608@vmdeb7>
References: <1417584992-2524-1-git-send-email-coproscefalo@gmail.com>
 <1417584992-2524-2-git-send-email-coproscefalo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417584992-2524-2-git-send-email-coproscefalo@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2014 at 10:36:31PM -0700, Azael Avalos wrote:
> The hotkey enabling code is being used by
> *_setup_keyboard and also by *_resume.
> 
> This patch creates a new function called
> toshiba_acpi_enable_hotkeys to be used by
> these two functions to avoid duplicating
> code.

42 is a little bit narrow, even for us kernel types :-) 72 characters wide is
fine.

Patch is fine, but since I had some questions on your others, please correct in
V2.

Thanks,

-- 
Darren Hart
Intel Open Source Technology Center
