Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752962AbaLIIHp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 03:07:45 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42432 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752454AbaLIIHn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 03:07:43 -0500
Date: Tue, 9 Dec 2014 09:08:00 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Andrew Duggan <aduggan@synaptics.com>
cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: Re: [PATCH] HID: rmi: The address of query8 must be calculated based
 on which query registers are present
In-Reply-To: <1418079720-11766-2-git-send-email-aduggan@synaptics.com>
Message-ID: <alpine.LNX.2.00.1412090907490.14413@pobox.suse.cz>
References: <1418079720-11766-1-git-send-email-aduggan@synaptics.com> <1418079720-11766-2-git-send-email-aduggan@synaptics.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Dec 2014, Andrew Duggan wrote:

> If a touchpad does not report relative data then query 6 will not be present and the address
> of query 8 will be one less. This patches calculates the location of query 8 instead of
> hardcoding the offset.
> 
> Signed-off-by: Andrew Duggan <aduggan@synaptics.com>

Applied to hid.git#for-3.19/rmi as well.

-- 
Jiri Kosina
SUSE Labs
