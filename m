Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752370Ab3CRWOs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 18:14:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39415 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751461Ab3CRWOk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 18:14:40 -0400
Date: Mon, 18 Mar 2013 23:14:36 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Stephane Chatty <chatty@enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] HID: multitouch: support of hybrid finger/pen
 devices
In-Reply-To: <1361984127-912-1-git-send-email-benjamin.tissoires@redhat.com>
Message-ID: <alpine.LNX.2.00.1303182313080.9529@pobox.suse.cz>
References: <1361984127-912-1-git-send-email-benjamin.tissoires@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Feb 2013, Benjamin Tissoires wrote:

> So the solution consists in relying inconditionaly to the quirk MULTI_INPUT for
> hid-multitouch. Before registering the input device in hid-input, we can test if
> it has been populated, and if not, then we simply don't register it. In order to
> prevent a regression for drivers that do not fill the input device, we need to
> add an other quirk.

Hi everybody,

I am in progress of reviewing this patchset, and so far don't have any 
major obejctions; I expect to have the review finished this week, so 3.10 
is definitely a realistic target.

Just to set my own expectations correctly -- Henrik, are you going to 
review this patchset as well, or there is no need for me to wait for your 
feedback?

Thanks,

-- 
Jiri Kosina
SUSE Labs
