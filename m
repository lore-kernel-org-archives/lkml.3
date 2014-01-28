Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298AbaA1Sgc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 13:36:32 -0500
Received: from mail-qa0-f52.google.com ([209.85.216.52]:35290 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754790AbaA1Sga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 13:36:30 -0500
MIME-Version: 1.0
In-Reply-To: <1390914382-3285-1-git-send-email-walken@google.com>
References: <1390914382-3285-1-git-send-email-walken@google.com>
From: Mike Waychison <mikew@google.com>
Date: Tue, 28 Jan 2014 10:36:07 -0800
Message-ID: <CAGTjWtAeHqZx3dLH93DDEFqsG5s=gBaauMnPS3ijFXT4-sD5qQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] Google firmware driver updates
To: Michel Lespinasse <walken@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Matt Fleming <matt.fleming@intel.com>, Tom Gundersen <teg@jklm.no>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Michel!

Acked-by: Mike Waychison <mikew@google.com>

On Tue, Jan 28, 2014 at 5:06 AM, Michel Lespinasse <walken@google.com> wrote:
> Two small fixes for google firmware drivers.
>
> The patches are against v3.13; I am proposing this for inclusion to v3.14.
>
> Michel Lespinasse (2):
>   firmware: fix google/gsmi duplicate efivars_sysfs_init()
>   drivers-firmware: google memconsole driver fixes
>
>  drivers/firmware/google/gsmi.c       |  7 ------
>  drivers/firmware/google/memconsole.c | 47 ++++++++++++++++++++----------------
>  2 files changed, 26 insertions(+), 28 deletions(-)
>
> --
> 1.8.5.3
>
