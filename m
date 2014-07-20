Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272AbaGTShu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 14:37:50 -0400
Received: from smtprelay-h21.telenor.se ([195.54.99.196]:41997 "EHLO
	smtprelay-h21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463AbaGTSht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 14:37:49 -0400
X-Greylist: delayed 1154 seconds by postgrey-1.27 at vger.kernel.org; Sun, 20 Jul 2014 14:37:48 EDT
X-SENDER-IP: [85.230.168.117]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjgCALgGzFNV5qh1PGdsb2JhbAANTItmxTUBgRwEAQEBATiEOgEBAwFpAQ8FCwshJQ8CECIUBgEMAQUCAQGIKgMJDah0kEANhyMXjR6CLQeERgEEmSKQFoliag
X-IPAS-Result: AjgCALgGzFNV5qh1PGdsb2JhbAANTItmxTUBgRwEAQEBATiEOgEBAwFpAQ8FCwshJQ8CECIUBgEMAQUCAQGIKgMJDah0kEANhyMXjR6CLQeERgEEmSKQFoliag
X-IronPort-AV: E=Sophos;i="5.01,696,1400018400"; 
   d="scan'208";a="45838286"
Message-ID: <53CC082B.70207@euromail.se>
Date: Sun, 20 Jul 2014 20:19:23 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org
CC: Benson Leung <bleung@chromium.org>, David Herrmann <dh.herrmann@gmail.com>,
        Andrew de los Reyes <adlr@chromium.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: fix defuzzing logic
References: <20140719234843.GA28580@core.coreip.homeip.net>
In-Reply-To: <20140719234843.GA28580@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

> We attempt to remove noise from coordinates reported by devices in
> input_handle_abs_event(), unfortunately, unless we were dropping the
> event altogether, we were ignoring the adjusted value and were passing
> on the original value instead.
> 
> Reviewed-by: Andrew de los Reyes <adlr@chromium.org>
> Reviewed-by: Benson Leung <bleung@chromium.org>
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> ---
>  drivers/input/input.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)

Oh my, that was a bad one.

Reviewed-by: Henrik Rydberg <rydberg@euromail.se>

Thanks,
Henrik


