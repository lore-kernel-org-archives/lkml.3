Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935493Ab3BTUGd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 15:06:33 -0500
Received: from smtprelay-b22.telenor.se ([195.54.99.213]:39179 "EHLO
	smtprelay-b22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935292Ab3BTUFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 15:05:04 -0500
X-SENDER-IP: [85.230.168.206]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AilGANIrJVFV5qjOPGdsb2JhbABFhWAiAYR9tV6BARcDAQEBATg0gh8BAQQBOhwTAQ8FCwgDISUPBQ0YChoTiAADCQq2cw2JWhWMIoJXB4JfYQOUUYFahgKFRYgd
X-IronPort-AV: E=Sophos;i="4.84,704,1355094000"; 
   d="scan'208";a="283964997"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Wed, 20 Feb 2013 21:06:25 +0100
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/7] HID: Kconfig: Remove explicit transport layer
 dependencies
Message-ID: <20130220200625.GA1321@polaris.bitmath.org>
References: <1360334256-22127-1-git-send-email-benjamin.tissoires@gmail.com>
 <1360334256-22127-4-git-send-email-benjamin.tissoires@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360334256-22127-4-git-send-email-benjamin.tissoires@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin,

> Most HID drivers (rightfully) only depend on the HID bus, not the
> specific transport layer. Remove such dependencies where applicable.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
> ---

I suppose you checked this list against newcomers as well, so:

    Acked-by: Henrik Rydberg <rydberg@euromail.se>

Thanks,
Henrik
