Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679Ab3IYJEY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 05:04:24 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:59491 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab3IYJEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 05:04:22 -0400
MIME-Version: 1.0
In-Reply-To: <5238F252.5070905@hurleysoftware.com>
References: <20130913005133.GA32479@localhost>
	<20130913010936.GA1291@localhost>
	<5238767D.1080606@hurleysoftware.com>
	<20130917232214.GA11390@localhost>
	<5238F252.5070905@hurleysoftware.com>
Date: Wed, 25 Sep 2013 17:04:21 +0800
Message-ID: <CAF1ivSbYg296oHhO0_UXwkos8Ui_1C93pUnXPzow4qLWyAa2kg@mail.gmail.com>
Subject: Re: increased vmap_area_lock contentions on "n_tty: Move buffers into n_tty_data"
From: Lin Ming <minggr@gmail.com>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, lkp@01.org,
        Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 18, 2013 at 8:22 AM, Peter Hurley <peter@hurleysoftware.com> wrote:
[snip]
>
> Looking over vmalloc.c, the critical section footprint of the vmap_area_lock
> could definitely be reduced (even nearly eliminated), but that's a project
> for
> another day :)

Hi Peter,

I also looked over vmallo.c, but didn't find obvious way to reduce the
critical section footprint.
Could you share some hints how to do this?

Thanks,
Lin Ming

>
> Regards,
> Peter Hurley
