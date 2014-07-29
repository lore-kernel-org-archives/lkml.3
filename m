Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753012AbaG2J3p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 05:29:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40114 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751619AbaG2J3o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 05:29:44 -0400
Date: Tue, 29 Jul 2014 11:29:42 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Andrew Duggan <aduggan@synaptics.com>
cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: Re: [PATCH v2] HID: rmi: check that report ids exist in the
 report_id_hash before accessing their size
In-Reply-To: <1405638885-8014-1-git-send-email-aduggan@synaptics.com>
Message-ID: <alpine.LNX.2.00.1407291129320.16390@pobox.suse.cz>
References: <1405638885-8014-1-git-send-email-aduggan@synaptics.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jul 2014, Andrew Duggan wrote:

> It is possible that the hid-rmi driver could get loaded onto a device which does not have the
> expected report ids. This should not happen because it would indicate that the hid-rmi driver is
> not compatible with that device. However, if it does happen it should return an error from probe
> instead of dereferencing a null pointer.
> 
> related bug:
> https://bugzilla.kernel.org/show_bug.cgi?id=80091
> 
> Signed-off-by: Andrew Duggan <aduggan@synaptics.com>

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs
