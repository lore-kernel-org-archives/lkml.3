Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476Ab3GXO5m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 10:57:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33540 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751605Ab3GXO5l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 10:57:41 -0400
Date: Wed, 24 Jul 2013 16:57:36 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3.11-rc2] HID: sony: fix HID mapping for PS3 sixaxis
 controller
In-Reply-To: <1374677587-8194-1-git-send-email-benjamin.tissoires@redhat.com>
Message-ID: <alpine.LNX.2.00.1307241657200.3167@pobox.suse.cz>
References: <1374677587-8194-1-git-send-email-benjamin.tissoires@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Jul 2013, Benjamin Tissoires wrote:

> Commit f04d51404f51 (HID: driver for PS2/3 Buzz controllers) introduced
> an input_mapping() callback, but set the return value to -1 to all devices
> except the Buzz controllers. The result of this is that the Sixaxis input
> device is not populated, making it useless.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> ---
> Hi Jiri,
> 
> I have since yesterday a Sixaxis controller on my desk, and I noticed that it
> was broken in v3.11.

Good catch, applied, thanks Benjamin.

-- 
Jiri Kosina
SUSE Labs
