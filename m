Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965004Ab3BTURs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 15:17:48 -0500
Received: from smtprelay-h22.telenor.se ([195.54.99.197]:44491 "EHLO
	smtprelay-h22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935287Ab3BTURp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 15:17:45 -0500
X-SENDER-IP: [85.230.168.206]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AidGAOwuJVFV5qjOPGdsb2JhbABFhWAiAYR9tV+BARcDAQEBATg0gh8BAQQBOhwjBQsIAyElDwUNGAoaE4gAAwkKtnYNiVoVjCKCVweCX2EDkm2BZIFahgKDWYFsiB0
X-IronPort-AV: E=Sophos;i="4.84,704,1355094000"; 
   d="scan'208";a="503874473"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Wed, 20 Feb 2013 21:18:31 +0100
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] HID: use hid_hw_wait() instead of direct call to
 usbhid
Message-ID: <20130220201831.GA1355@polaris.bitmath.org>
References: <1360334256-22127-1-git-send-email-benjamin.tissoires@gmail.com>
 <1360334256-22127-6-git-send-email-benjamin.tissoires@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360334256-22127-6-git-send-email-benjamin.tissoires@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin,

> This removes most of the dependencies between hid drivers and usbhid.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
> ---

Same here, I think a more substantial commit log is in order.

Thanks,
Henrik
