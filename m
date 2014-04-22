Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932434AbaDVLzJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 07:55:09 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:52900 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755594AbaDVLzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 07:55:04 -0400
MIME-Version: 1.0
In-Reply-To: <535631EB.4060906@redhat.com>
References: <1395256011-2423-1-git-send-email-dh.herrmann@gmail.com>
	<5343F2EC.3050508@redhat.com>
	<CANq1E4TmtR=gSgR25PGC_EN=xrEEg1+F=zkTUGXZ4SHvjFNbag@mail.gmail.com>
	<535631EB.4060906@redhat.com>
Date: Tue, 22 Apr 2014 13:55:03 +0200
Message-ID: <CANq1E4TufnELwEDZAkzH94Zn3gb46qvxfDboN5y2mK=Q2gk9-Q@mail.gmail.com>
Subject: Re: [PATCH 0/6] File Sealing & memfd_create()
From: David Herrmann <dh.herrmann@gmail.com>
To: Florian Weimer <fweimer@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Kay Sievers <kay@vrfy.org>,
        Daniel Mack <zonque@gmail.com>,
        Lennart Poettering <lennart@poettering.net>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Tue, Apr 22, 2014 at 11:10 AM, Florian Weimer <fweimer@redhat.com> wrote:
> Ah.  What do you recommend for recipient to recognize such descriptors?
> Would they just try to seal them and reject them if this fails?

This highly depends on your use-case. Please see the initial email in
this thread. It describes 2 example use-cases. In both cases, the
recipients read the current set of seals and verify that a given set
of seals is set.

Thanks
David
