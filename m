Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752311Ab3KUE4f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 23:56:35 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:45397 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860Ab3KUE4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 23:56:33 -0500
Date: Wed, 20 Nov 2013 20:56:21 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, David Herrmann <dh.herrmann@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Antonio Ospite <ospite@studenti.unina.it>, simon@mungewell.org,
        case@corpsmoderne.net, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Only process ABS_MT_SLOT where there are slots
 available
Message-ID: <20131121045620.GA4702@core.coreip.homeip.net>
References: <1384983141-31019-1-git-send-email-benjamin.tissoires@redhat.com>
 <1384983141-31019-2-git-send-email-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384983141-31019-2-git-send-email-benjamin.tissoires@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin, Antonio,

On Wed, Nov 20, 2013 at 04:32:19PM -0500, Benjamin Tissoires wrote:
> From: Antonio Ospite <ospite@studenti.unina.it>
> 
> This fixes the case when a non-multitouch device happens to have a HID
> code equal to ABS_MT_SLOT, like the Sony Sixaxis has for the left dpad
> analog control.
> 
> Updated to latest tree by Benjamin Tissoires.

I do not think this is a proper way to address the issue. Generic HID
driver should not encroach onto multitouch ABS range and either stop
mapping absolute axis or map them properly.

Thanks.

-- 
Dmitry
