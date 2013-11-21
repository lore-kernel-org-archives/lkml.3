Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403Ab3KUE6F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 23:58:05 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38994 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860Ab3KUE6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 23:58:03 -0500
Date: Wed, 20 Nov 2013 20:57:52 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, David Herrmann <dh.herrmann@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Antonio Ospite <ospite@studenti.unina.it>, simon@mungewell.org,
        case@corpsmoderne.net, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] input: Introduce INPUT_PROP_MT
Message-ID: <20131121045750.GB4702@core.coreip.homeip.net>
References: <1384983141-31019-1-git-send-email-benjamin.tissoires@redhat.com>
 <1384983141-31019-3-git-send-email-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384983141-31019-3-git-send-email-benjamin.tissoires@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 20, 2013 at 04:32:20PM -0500, Benjamin Tissoires wrote:
> There may be a clash with devices presenting a lot of absolute axis
> (like the PS3 Sixaxis) and true multitouch devices. Both those kinds
> of devices may present some ABS_MT_* capabilities, so setting this
> property ensures user-space knows what to do with the input device.
> 

No, let's not use the same ABS_* values to mean different things and
define proper values instead.

Thanks.

-- 
Dmitry
