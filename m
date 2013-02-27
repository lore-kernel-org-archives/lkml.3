Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932363Ab3B0Mfc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 07:35:32 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:59514 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759870Ab3B0Mf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 07:35:29 -0500
MIME-Version: 1.0
In-Reply-To: <20130211231500.GD21501@hansolo.jdub.homelinux.org>
References: <20130211231500.GD21501@hansolo.jdub.homelinux.org>
From: Kay Sievers <kay@vrfy.org>
Date: Wed, 27 Feb 2013 13:35:07 +0100
Message-ID: <CAPXgP11TQ01QZXAnNHA81rdt3WdYQfixKxit28+iGHysiAUenw@mail.gmail.com>
Subject: Re: [PATCH] pstore: Create a convenient mount point for pstore
To: Josh Boyer <jwboyer@redhat.com>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>, Colin Cross <ccross@android.com>,
        Kees Cook <keescook@chromium.org>, Tony Luck <tony.luck@intel.com>,
        kay@redhat.com, lpoetter@redhat.com, mjg59@srcf.ucam.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2013 at 12:15 AM, Josh Boyer <jwboyer@redhat.com> wrote:
> Using /dev/pstore as a mount point for the pstore filesystem is slightly
> awkward.  We don't normally mount filesystems in /dev/ and the /dev/pstore
> file isn't created automatically by anything.  While this method will
> still work, we can create a persistent mount point in sysfs.  This will
> put pstore on par with things like cgroups and efivarfs.

Mounted by default now, if available:
  http://cgit.freedesktop.org/systemd/systemd/commit/?id=c06bf414042cd1bf94e0af63e9e2a0c291bfc546

Thanks everybody,
Kay
