Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934411AbaDIVbW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 17:31:22 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:36631 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933717AbaDIVbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 17:31:20 -0400
MIME-Version: 1.0
In-Reply-To: <5343F2EC.3050508@redhat.com>
References: <1395256011-2423-1-git-send-email-dh.herrmann@gmail.com>
	<5343F2EC.3050508@redhat.com>
Date: Wed, 9 Apr 2014 23:31:20 +0200
Message-ID: <CANq1E4TmtR=gSgR25PGC_EN=xrEEg1+F=zkTUGXZ4SHvjFNbag@mail.gmail.com>
Subject: Re: [PATCH 0/6] File Sealing & memfd_create()
From: David Herrmann <dh.herrmann@gmail.com>
To: Florian Weimer <fweimer@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Kay Sievers <kay@vrfy.org>,
        Daniel Mack <zonque@gmail.com>,
        Lennart Poettering <lennart@poettering.net>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Tue, Apr 8, 2014 at 3:00 PM, Florian Weimer <fweimer@redhat.com> wrote:
> How do you keep these promises on network and FUSE file systems?

I don't. This is shmem only.

Thanks
David
