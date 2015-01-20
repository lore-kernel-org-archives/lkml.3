Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752943AbbATLPk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 06:15:40 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47133 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752455AbbATLPj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 06:15:39 -0500
Message-ID: <1421752526.29486.18.camel@linux-0dmf.site>
Subject: Re: [PATCH v2 0/4] toshiba_acpi: Add support for USB Sleep functions
From: Oliver Neukum <oneukum@suse.de>
To: Azael Avalos <coproscefalo@gmail.com>
Cc: Darren Hart <dvhart@infradead.org>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Date: Tue, 20 Jan 2015 12:15:26 +0100
In-Reply-To: <1421631025-27895-1-git-send-email-coproscefalo@gmail.com>
References: <1421631025-27895-1-git-send-email-coproscefalo@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2015-01-18 at 18:30 -0700, Azael Avalos wrote:
> The following patches add support to several USB Sleep functions
> found on newer Toshiba laptops, allowing to use the USB ports while
> the laptop is asleep or turned off.

Hi,

this is most interesting. But the interface is terrible. If
possible we would like to have a generic interface for this,
which should not depend on the specific platform in use and would
have to be per bus or even per port (for example the ports on a
Thunderbolt dock would not work with your module).
Do you think we could provide a hook from generic code into
platform code to detect the capability for power control?

	Regards
		Oliver



