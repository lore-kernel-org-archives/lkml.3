Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933957AbaEMOob (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 10:44:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57756 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759811AbaEMOo3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 10:44:29 -0400
Date: Tue, 13 May 2014 16:44:28 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
cc: Andrew Duggan <aduggan@synaptics.com>,
        Christopher Heiny <cheiny@synaptics.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: rmi: do not fetch more than 16 bytes in a query
In-Reply-To: <1398378398-24825-1-git-send-email-benjamin.tissoires@redhat.com>
Message-ID: <alpine.LNX.2.00.1405131643330.16459@pobox.suse.cz>
References: <1398378398-24825-1-git-send-email-benjamin.tissoires@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Apr 2014, Benjamin Tissoires wrote:

> A firmware bug is present on the XPS Haswell edition which silently
> split the request in two responses when the caller ask for a read of
> more than 16 bytes.
> The FW sends the first 16 then the 4 next, but it says that it answered
> the 20 bytes in the first report.
> 
> This occurs only on the retrieving of the min/max of X and Y of the F11
> function.
> We only use the first 10 bytes of the Ctrl register, so we can get only
> those 10 bytes to prevent the bug from happening.
> 
> Resolves:
> https://bugzilla.redhat.com/show_bug.cgi?id=1090161
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs
