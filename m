Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756592AbaF3MuJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:50:09 -0400
Received: from mail-ve0-f175.google.com ([209.85.128.175]:33908 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755407AbaF3MuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 08:50:03 -0400
MIME-Version: 1.0
In-Reply-To: <53B15A94.3010402@vmware.com>
References: <1395967502-71219-1-git-send-email-chrisfriedt@gmail.com>
 <CAPM=9tx4hdU0PZqdZcCd-x3HMu+6ZsGibeOHZPLe3OpW9Wsa0g@mail.gmail.com>
 <533A8E52.5050304@vmware.com> <CAF4BF-Rmxqbbd_xroQbRTWeE2NfKAZm=Jm7SG2bNppHV2odYNA@mail.gmail.com>
 <53B14E9E.3040505@vmware.com> <CAF4BF-T4VZQtd_3wWfNQ_==KJE0z0N5XonG4jcy=Ys5x_XxJ=w@mail.gmail.com>
 <53B15A94.3010402@vmware.com>
From: Christopher Friedt <chrisfriedt@gmail.com>
Date: Mon, 30 Jun 2014 08:49:40 -0400
Message-ID: <CAF4BF-TiHkaaOejH6p1QnnepfOxmvirds3vQD2YdXih_6kkUpQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] drm/vmwgfx: correct fb_fix_screeninfo.line_length
To: Thomas Hellstrom <thellstrom@vmware.com>
Cc: dri-devel <dri-devel@lists.freedesktop.org>, linux-kernel@vger.kernel.org,
        Dave Airlie <airlied@gmail.com>, linux-graphics-maintainer@vmware.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2014 at 8:39 AM, Thomas Hellstrom <thellstrom@vmware.com> wrote:
> xf86-video-vmware in kms mode uses the kernel driver to set these registers.
> FWIW, the modesetting part of the kernel driver uses SVGA_REG_PITCHLOCK
> instead of
> SVGA_REG_BYTES_PER_LINE to set the pitch. That's probably where the
> clash happens.

That sounds a bit more accurate. Should kms and fbdev be setting both
registers then?
