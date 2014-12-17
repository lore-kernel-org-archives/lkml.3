Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752008AbaLQHzF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 02:55:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40622 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751602AbaLQHzD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 02:55:03 -0500
Date: Wed, 17 Dec 2014 08:55:01 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Peter Wu <peter@lekensteyn.nl>
cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Nestor Lopez Casado <nlopezcasad@logitech.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] HID: logitech-hidpp: separate HID++ from WTP
 processing
In-Reply-To: <1418772231-31330-1-git-send-email-peter@lekensteyn.nl>
Message-ID: <alpine.LNX.2.00.1412170854500.1680@pobox.suse.cz>
References: <CAN+gG=GhJx38LDwAGoPA1BpYOmjS8r_xnYPXWOgB66VLwmv5kg@mail.gmail.com> <1418772231-31330-1-git-send-email-peter@lekensteyn.nl>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Dec 2014, Peter Wu wrote:

> Previously wtp_raw_event would be called through
> hidpp_raw_hidpp_event (for the touchpad report) and hidpp_raw_event
> (for the mouse report).
> 
> This patch removes one calling surface, making a clearer distinction
> between "generic HID++ processing" (matching internal reports) and
> device-specific event processing.
> 
> Suggested-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> Signed-off-by: Peter Wu <peter@lekensteyn.nl>
> Reviewed-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> ---
>  v1: patch 2/3 HID: logitech-{dj,hidpp}: check report length
>  v2: splitted original report length check patch. Restructured code.
>  v3: renamed var r to ret for consistency, added R-b of Benjamin

Applied to for-3.20/logitech.

Thanks,

-- 
Jiri Kosina
SUSE Labs
