Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751396AbaAPVuM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 16:50:12 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53278 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750750AbaAPVuJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 16:50:09 -0500
Date: Thu, 16 Jan 2014 22:50:04 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Nestor Lopez Casado <nlopezcasad@logitech.com>,
        Andrew de los Reyes <adlr@chromium.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] HID: logitech-dj: Fix USB 3.0 issue
In-Reply-To: <1389219529-29671-2-git-send-email-benjamin.tissoires@redhat.com>
Message-ID: <alpine.LNX.2.00.1401162249150.23018@pobox.suse.cz>
References: <1389219529-29671-1-git-send-email-benjamin.tissoires@redhat.com> <1389219529-29671-2-git-send-email-benjamin.tissoires@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Jan 2014, Benjamin Tissoires wrote:

> From: Benjamin Tisssoires <benjamin.tissoires@redhat.com>
> 
> This fix (not very clean though) should fix the long time USB3
> issue that was spotted last year. The rational has been given by
> Hans de Goede:

Man this is so ugly ... makes one wonder how come that other OSes don't 
suffer from this. Are they really *that much* slower? :)

I have applied this (and just this) one for 3.14.

Thanks,

-- 
Jiri Kosina
SUSE Labs
