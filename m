Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482AbaF0OEe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 10:04:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59410 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752740AbaF0OEd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 10:04:33 -0400
Date: Fri, 27 Jun 2014 16:04:31 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: John Sung <penmount.touch@gmail.com>
cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: usbhid: quirk for PM1610 and PM1640 Touchscreen.
In-Reply-To: <1403857328-38892-1-git-send-email-penmount.touch@gmail.com>
Message-ID: <alpine.LNX.2.00.1406271604220.21386@pobox.suse.cz>
References: <1403857328-38892-1-git-send-email-penmount.touch@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jun 2014, John Sung wrote:

> These device needs to be added to the quirks list with HID_QUIRK_NOGET,
> otherwise they will reset upon receiving the get input report requests.
> 
> Signed-off-by: John Sung <penmount.touch@gmail.com>

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs
