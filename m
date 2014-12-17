Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751600AbaLQJiP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 04:38:15 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42216 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751456AbaLQJiM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 04:38:12 -0500
Date: Wed, 17 Dec 2014 10:38:10 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
cc: Peter Wu <peter@lekensteyn.nl>,
        Nestor Lopez Casado <nlopezcasad@logitech.com>,
        Peter Hutterer <peter.hutterer@who-t.net>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] HID: logitech-hidpp: prefix the name with Logitech
In-Reply-To: <1418337599-10239-1-git-send-email-benjamin.tissoires@redhat.com>
Message-ID: <alpine.LNX.2.00.1412171037200.1680@pobox.suse.cz>
References: <1418337599-10239-1-git-send-email-benjamin.tissoires@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Dec 2014, Benjamin Tissoires wrote:

> Current names are reported as "K750", "M705", and it can be misleading
> for the users when they look at their input device list.
> 
> Prefixing the names with "Logitech " makes things better.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> ---
> 
> Changes in v2:
> - renamed PREFIX_SIZE into PREFIX_LENGTH
> - changed "name_length + PREFIX_LENGTH;" into "PREFIX_LENGTH + name_length;"
> - rebased on Peter's last patch series

Ok, looks reasonable. I was waiting whether someone from Logitech would 
comment on the prefix check that could be used other than "Logitech".

But we can add that later.

Applied to for-3.20/logitech, thanks.

-- 
Jiri Kosina
SUSE Labs
