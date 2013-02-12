Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760851Ab3BLAPR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 19:15:17 -0500
Received: from mail-oa0-f54.google.com ([209.85.219.54]:63853 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760145Ab3BLAPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 19:15:15 -0500
MIME-Version: 1.0
In-Reply-To: <20130211231500.GD21501@hansolo.jdub.homelinux.org>
References: <20130211231500.GD21501@hansolo.jdub.homelinux.org>
Date: Mon, 11 Feb 2013 16:15:13 -0800
X-Google-Sender-Auth: w-bIzmRJyJPI_pMmMDACscI57-E
Message-ID: <CAGXu5jKLru4Vq1ZCcubT5=hucT0TxpJ0VZ88MkiJ=g5sJ4u_vg@mail.gmail.com>
Subject: Re: [PATCH] pstore: Create a convenient mount point for pstore
From: Kees Cook <keescook@chromium.org>
To: Josh Boyer <jwboyer@redhat.com>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>, Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>, kay@redhat.com, lpoetter@redhat.com,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2013 at 3:15 PM, Josh Boyer <jwboyer@redhat.com> wrote:
> Using /dev/pstore as a mount point for the pstore filesystem is slightly
> awkward.  We don't normally mount filesystems in /dev/ and the /dev/pstore
> file isn't created automatically by anything.  While this method will
> still work, we can create a persistent mount point in sysfs.  This will
> put pstore on par with things like cgroups and efivarfs.
>
> Signed-off-by: Josh Boyer <jwboyer@redhat.com>

Acked-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
Chrome OS Security
