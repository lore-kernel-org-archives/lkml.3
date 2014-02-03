Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751782AbaBCKDM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 05:03:12 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55798 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750936AbaBCKDK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 05:03:10 -0500
Date: Mon, 3 Feb 2014 11:03:05 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: fix buffer allocations
In-Reply-To: <1391314990-29046-1-git-send-email-benjamin.tissoires@redhat.com>
Message-ID: <alpine.LNX.2.00.1402031102110.14066@pobox.suse.cz>
References: <1391314990-29046-1-git-send-email-benjamin.tissoires@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 1 Feb 2014, Benjamin Tissoires wrote:

> When using hid_output_report(), the buffer should be allocated by hid_alloc_report_buf(),
> not a custom malloc.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

Good catch, applied, thanks.

-- 
Jiri Kosina
SUSE Labs
