Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755748AbaKTNVb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 08:21:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56077 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751103AbaKTNV3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 08:21:29 -0500
Date: Thu, 20 Nov 2014 14:21:36 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
cc: Mathieu Magnaudet <mathieu.magnaudet@gmail.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hid-multitouch: Add quirk for VTL touch panels
In-Reply-To: <CAN+gG=GN4dwXr_qEHMfMddGHkMKECZMUwTM+xbNmY_gibthLmA@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1411201421100.4454@pobox.suse.cz>
References: <1416422480-3241-1-git-send-email-mathieu.magnaudet@enac.fr> <CAN+gG=GN4dwXr_qEHMfMddGHkMKECZMUwTM+xbNmY_gibthLmA@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Nov 2014, Benjamin Tissoires wrote:

> though this patch works for this particular device, I just thought at
> something which may solve the problem in a different way. I asked
> Mathieu to test the different solution, so I'd rather you to wait for
> final confirmation before merging this patch.

Thanks for the heads up, I am putting this patch on hold until further 
notice from you or Mathieu.

-- 
Jiri Kosina
SUSE Labs
