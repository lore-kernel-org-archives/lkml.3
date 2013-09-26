Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168Ab3IZJGX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 05:06:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38939 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755292Ab3IZJGV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 05:06:21 -0400
Date: Thu, 26 Sep 2013 11:06:16 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: Tom Gundersen <teg@jklm.no>, Marcel Holtmann <marcel@holtmann.org>,
        Kay Sievers <kay@vrfy.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [BUG?] HID: uhid: add devname module alias
In-Reply-To: <CANq1E4QNE7v1fV71E8EwPiKRR1A63erVKVYO07mJ0ySD+etG6g@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1309261106050.18703@pobox.suse.cz>
References: <CAG-2HqXVR5rFCa0XGmFpJcPWgPBKKaELgmFxhWKxxOYQRc-m2A@mail.gmail.com> <CANq1E4QNE7v1fV71E8EwPiKRR1A63erVKVYO07mJ0ySD+etG6g@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Sep 2013, David Herrmann wrote:

> >
> > The above commit (60cbd53 in mainline) doesn't appear to work for me.
> > I.e., depmod does not create an entry in modules.devname and hence no
> > device node is created on boot.
> >
> > If I understand correctly, you'd also need to create the correct
> > "char-major-<MAJOR>-<MINOR>" alias (which I don't think you can do as
> > long as you are using MISC_DYNAMIC_MINOR).
> >
> > Or am I missing something?
> 
> Nope, that's correct as discussed on IRC. Patch pending as:
>   Subject: [PATCH] HID: uhid: allocate static minor
>   Message-Id: <1378744434-10883-1-git-send-email-dh.herrmann@gmail.com>

I have now queued that one. Thanks,

-- 
Jiri Kosina
SUSE Labs
