Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095AbaF3NWb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 09:22:31 -0400
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:41179 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750985AbaF3NWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 09:22:30 -0400
Message-ID: <53B16492.6040006@vmware.com>
Date: Mon, 30 Jun 2014 15:22:26 +0200
From: Thomas Hellstrom <thellstrom@vmware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Christopher Friedt <chrisfriedt@gmail.com>
CC: dri-devel <dri-devel@lists.freedesktop.org>, linux-kernel@vger.kernel.org,
        Dave Airlie <airlied@gmail.com>, linux-graphics-maintainer@vmware.com
Subject: Re: [PATCH 1/1] drm/vmwgfx: correct fb_fix_screeninfo.line_length
References: <1395967502-71219-1-git-send-email-chrisfriedt@gmail.com> <CAPM=9tx4hdU0PZqdZcCd-x3HMu+6ZsGibeOHZPLe3OpW9Wsa0g@mail.gmail.com> <533A8E52.5050304@vmware.com> <CAF4BF-Rmxqbbd_xroQbRTWeE2NfKAZm=Jm7SG2bNppHV2odYNA@mail.gmail.com> <53B14E9E.3040505@vmware.com> <CAF4BF-T4VZQtd_3wWfNQ_==KJE0z0N5XonG4jcy=Ys5x_XxJ=w@mail.gmail.com> <53B15A94.3010402@vmware.com> <CAF4BF-TiHkaaOejH6p1QnnepfOxmvirds3vQD2YdXih_6kkUpQ@mail.gmail.com> <CAF4BF-T8a_Y=uW7r_g0WKpABHFH=GhX0hNAQMsG9o=DX4JF6qg@mail.gmail.com>
In-Reply-To: <CAF4BF-T8a_Y=uW7r_g0WKpABHFH=GhX0hNAQMsG9o=DX4JF6qg@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/30/2014 03:18 PM, Christopher Friedt wrote:
> On Mon, Jun 30, 2014 at 8:49 AM, Christopher Friedt
> <chrisfriedt@gmail.com> wrote:
>> That sounds a bit more accurate. Should kms and fbdev be setting both
>> registers then?
> I wonder if fbdev can use PITCHLOCK as well, rather than
> BYTES_PER_LINE. I will only be able to run both kms and fbdev
> functional tests about 9 hours from now, so any discussion until then
> is welcome

Please see the previous message I sent. If you just remove the line that
sets BYTES_PER_LINE,
fbdev will have called into the kms code to set PITCHLOCK correctly.

/Thomas
