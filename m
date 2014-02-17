Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788AbaBQWbo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 17:31:44 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51039 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753418AbaBQWbm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 17:31:42 -0500
Date: Mon, 17 Feb 2014 23:31:37 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: David Barksdale <dbarksdale@uplogix.com>
cc: David Herrmann <dh.herrmann@gmail.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Oliver Neukum <oliver@neukum.org>,
        =?ISO-8859-15?Q?Jakub_K=E1kona?= <kjakub@gmail.com>,
        Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5] HID: New hid-cp2112 driver
In-Reply-To: <1391539368-22688-1-git-send-email-dbarksdale@uplogix.com>
Message-ID: <alpine.LNX.2.00.1402172330560.1192@pobox.suse.cz>
References: <1391539368-22688-1-git-send-email-dbarksdale@uplogix.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Feb 2014, David Barksdale wrote:

> This patch adds support for the Silicon Labs CP2112
> "Single-Chip HID USB to SMBus Master Bridge."
> 
> This is a HID device driver which registers as an i2c adapter
> and gpiochip to expose these functions of the CP2112. The
> customizable USB descriptor fields are exposed as sysfs attributes.
> The SMBus byte-read, byte-data-read/write, and word-data-read
> transfer modes have been tested by talking to an i2c sensor.
> The GPIO functions and USB descriptor field programming have also
> been tested.
> 
> Signed-off-by: David Barksdale <dbarksdale@uplogix.com>

I have applied the driver. David, please send any followup patches as a 
followup to branch for-3.15/hid-cp2112 in hid.git.

Thanks,

-- 
Jiri Kosina
SUSE Labs
