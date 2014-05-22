Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596AbaEVJPe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 05:15:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34729 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751066AbaEVJPc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 05:15:32 -0400
Date: Thu, 22 May 2014 11:15:28 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
cc: Andrew Duggan <aduggan@synaptics.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] HID: rmi: do not handle touchscreens through
 hid-rmi
In-Reply-To: <1400685356-6126-1-git-send-email-benjamin.tissoires@redhat.com>
Message-ID: <alpine.LNX.2.00.1405221115160.12047@pobox.suse.cz>
References: <1400685356-6126-1-git-send-email-benjamin.tissoires@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 May 2014, Benjamin Tissoires wrote:

> Currently, hid-rmi drives every Synaptics product, but the touchscreens
> on the Windows tablets should be handled through hid-multitouch.
> 
> Instead of providing a long list of PIDs, rely on the scan_report
> capability to detect which should go to hid-multitouch, and which
> should not go to hid-rmi.
> 
> related bug:
> https://bugzilla.kernel.org/show_bug.cgi?id=74241
> https://bugzilla.redhat.com/show_bug.cgi?id=1089583
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs
