Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751940AbaGBDBz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 23:01:55 -0400
Received: from mail-ve0-f169.google.com ([209.85.128.169]:58985 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607AbaGBDBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 23:01:53 -0400
MIME-Version: 1.0
In-Reply-To: <53B16492.6040006@vmware.com>
References: <1395967502-71219-1-git-send-email-chrisfriedt@gmail.com>
 <CAPM=9tx4hdU0PZqdZcCd-x3HMu+6ZsGibeOHZPLe3OpW9Wsa0g@mail.gmail.com>
 <533A8E52.5050304@vmware.com> <CAF4BF-Rmxqbbd_xroQbRTWeE2NfKAZm=Jm7SG2bNppHV2odYNA@mail.gmail.com>
 <53B14E9E.3040505@vmware.com> <CAF4BF-T4VZQtd_3wWfNQ_==KJE0z0N5XonG4jcy=Ys5x_XxJ=w@mail.gmail.com>
 <53B15A94.3010402@vmware.com> <CAF4BF-TiHkaaOejH6p1QnnepfOxmvirds3vQD2YdXih_6kkUpQ@mail.gmail.com>
 <CAF4BF-T8a_Y=uW7r_g0WKpABHFH=GhX0hNAQMsG9o=DX4JF6qg@mail.gmail.com> <53B16492.6040006@vmware.com>
From: Christopher Friedt <chrisfriedt@gmail.com>
Date: Tue, 1 Jul 2014 23:01:32 -0400
Message-ID: <CAF4BF-R_b0_7tzqsMu0UENYtdQ7P=2x6ELLhMB38_4u9Fc58RQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] drm/vmwgfx: correct fb_fix_screeninfo.line_length
To: Thomas Hellstrom <thellstrom@vmware.com>
Cc: dri-devel <dri-devel@lists.freedesktop.org>, linux-kernel@vger.kernel.org,
        Dave Airlie <airlied@gmail.com>, linux-graphics-maintainer@vmware.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have been unable to reproduce this issue in a plethora of test
cases, although granted, I do not have access to a Win7 machine. For
that, I have asked an Ubuntu tester to run through some tests for me.

https://bugs.launchpad.net/ubuntu/+source/xserver-xorg-video-vmware/+bug/1328898/comments/8

Will post updates as I receive them.
