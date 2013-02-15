Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751983Ab3BOTpj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 14:45:39 -0500
Received: from smtprelay-h21.telenor.se ([195.54.99.196]:58416 "EHLO
	smtprelay-h21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035Ab3BOTph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 14:45:37 -0500
X-SENDER-IP: [85.230.168.206]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiNEAOqPHlFV5qjOPGdsb2JhbABEhgIBhH20d3wXAwEBAQE4NIIfAQEFOhwTAQ8QCAMYCSUPBQ0YChoTiAADE7NfDYlaFYw9glkHgl9hA5ROgVmGAYVCiBs
X-IronPort-AV: E=Sophos;i="4.84,675,1355094000"; 
   d="scan'208";a="204074411"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Fri, 15 Feb 2013 20:46:23 +0100
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] HID: Extend the interface with report requests
Message-ID: <20130215194623.GA8867@polaris.bitmath.org>
References: <1360334256-22127-1-git-send-email-benjamin.tissoires@gmail.com>
 <1360334256-22127-2-git-send-email-benjamin.tissoires@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360334256-22127-2-git-send-email-benjamin.tissoires@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08, 2013 at 03:37:30PM +0100, Benjamin Tissoires wrote:
> Some drivers send reports directly to underlying device, creating an
> unwanted dependency on the underlying transport layer. This patch adds
> hid_hw_request() to the interface, thereby removing usbhid from the
> lion share of the drivers.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
> ---
>  drivers/hid/usbhid/hid-core.c | 13 +++++++++++++
>  include/linux/hid.h           | 20 ++++++++++++++++++++
>  2 files changed, 33 insertions(+)

    Signed-off-by: Henrik Rydberg <rydberg@euromail.se>

Thanks, Benjamin.
Henrik
