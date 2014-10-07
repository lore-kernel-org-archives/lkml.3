Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036AbaJGTHy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 15:07:54 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:58053 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754325AbaJGTHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 15:07:51 -0400
MIME-Version: 1.0
In-Reply-To: <CAB=NE6V_1yyYPhzbV_yRzt7fg=_8yF2YYNBz4qH_2TbH0nozcw@mail.gmail.com>
References: <1412372683-2003-1-git-send-email-mcgrof@do-not-panic.com>
 <1412372683-2003-8-git-send-email-mcgrof@do-not-panic.com>
 <20141006201926.GF18303@htj.dyndns.org> <20141006203627.GZ14081@wotan.suse.de>
 <20141006210118.GG18303@htj.dyndns.org> <20141006231046.GD14081@wotan.suse.de>
 <20141007173404.GB31328@mtj.dyndns.org> <20141007175010.GH14081@wotan.suse.de>
 <20141007175503.GE31328@mtj.dyndns.org> <CAB=NE6V_1yyYPhzbV_yRzt7fg=_8yF2YYNBz4qH_2TbH0nozcw@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@suse.com>
Date: Tue, 7 Oct 2014 12:07:29 -0700
X-Google-Sender-Auth: dJY2B9B8Gy6tqwBrgBM93DvW-J8
Message-ID: <CAB=NE6X1zf6JYxiitvoOi-7OcmvhSJyP2oVE4gCF5JgfqhAyQA@mail.gmail.com>
Subject: Re: [PATCH v2 7/7] driver-core: add preferred async probe option for
 built-in and modules
To: Tejun Heo <tj@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Takashi Iwai <tiwai@suse.de>, Arjan van de Ven <arjan@linux.intel.com>,
        Tom Gundersen <teg@jklm.no>, Robert Milasan <rmilasan@suse.com>,
        werner@suse.com, Oleg Nesterov <oleg@redhat.com>, hare <hare@suse.com>,
        Benjamin Poirier <bpoirier@suse.de>,
        Santosh Rastapur <santosh@chelsio.com>, Petr Mladek <pmladek@suse.cz>,
        dbueso@suse.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Joseph Salisbury <joseph.salisbury@canonical.com>,
        Kay Sievers <kay@vrfy.org>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Tim Gardner <tim.gardner@canonical.com>,
        Pierre Fersing <pierre-fersing@pierref.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>,
        Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>,
        Sreekanth Reddy <sreekanth.reddy@avagotech.com>,
        Abhijit Mahajan <abhijit.mahajan@avagotech.com>,
        Casey Leedom <leedom@chelsio.com>,
        Hariprasad S <hariprasad@chelsio.com>,
        "mpt-fusionlinux.pdl" <MPT-FusionLinux.pdl@avagotech.com>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 7, 2014 at 11:55 AM, Luis R. Rodriguez <mcgrof@suse.com> wrote:
> OK I'll just kill bus.enable_kern_async=1 to enable built-in async
> probe support *and* also have prefer_async_probe *always* be
> respected, whether modular or not.

Well and I just realized you *do* want to flush, so will throw that in
too without an option to skip it.

 Luis
