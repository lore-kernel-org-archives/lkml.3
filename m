Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935959Ab3BTUVb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 15:21:31 -0500
Received: from smtprelay-b22.telenor.se ([195.54.99.213]:52938 "EHLO
	smtprelay-b22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964841Ab3BTUPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 15:15:39 -0500
X-SENDER-IP: [85.230.168.206]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AidGAOQtJVFV5qjOPGdsb2JhbABFhWAiAYR9tV+BARcDAQEBATg0gh8BAQQBOhwjBQsIAyElDwUNGAoaE4gAAwkKtngNiVoVjCKCVweCX2EDkm2BZIFahgKDWYFsiB0
X-IronPort-AV: E=Sophos;i="4.84,704,1355094000"; 
   d="scan'208";a="503874101"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Wed, 20 Feb 2013 21:16:56 +0100
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/7] hid: use hid_hw_request() instead of direct call to
 usbhid
Message-ID: <20130220201656.GA1346@polaris.bitmath.org>
References: <1360334256-22127-1-git-send-email-benjamin.tissoires@gmail.com>
 <1360334256-22127-5-git-send-email-benjamin.tissoires@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360334256-22127-5-git-send-email-benjamin.tissoires@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin,

> This allows the hid drivers to be independent from the transport layer.

Since the patch is pretty large, a few lines on how it was constructed
might be in order. Something like "by replacing all occurences of
usbhid_submit_report() by its hid_hw_request() counterpart".

Also, the list of dependency changes only contains the drivers that
actually become completely decoupled with this patch. The drivers that
also depend on the io wait are found in the next patch.

> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
> ---

Thanks,
Henrik
