Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679AbaG3LuS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 07:50:18 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:46158 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307AbaG3LuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 07:50:17 -0400
MIME-Version: 1.0
In-Reply-To: <8487820.GRUnuPqyXT@vostro.rjw.lan>
References: <5386F2C7.8080400@redhat.com> <2026468.U7VDB8Dm9m@vostro.rjw.lan>
 <CAHTgTXXejANtoEeeUB59DTy1kU3ROYoOsNi-fLu==PAr6Kh+-Q@mail.gmail.com> <8487820.GRUnuPqyXT@vostro.rjw.lan>
From: William Dauchy <wdauchy@gmail.com>
Date: Wed, 30 Jul 2014 13:49:55 +0200
Message-ID: <CAJ75kXa_h=A9yLjG=BtY4Fk_GY+37fb+u1x1wVy2n9X8S-P9KQ@mail.gmail.com>
Subject: Re: WARNING: CPU: 0 PID: 2623 at drivers/pnp/pnpacpi/core.c:96 pnpacpi_set_resource
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Vinson Lee <vlee@twopensource.com>, Zdenek Kabelac <zkabelac@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

On Wed, Jul 30, 2014 at 12:39 AM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> William, it would be good if you could test it too as I'd like to
> push it for 3.16.

It also fixes the issue in 3.14.x

Tested-by: William Dauchy <william@gandi.net>

Thanks,
-- 
William
