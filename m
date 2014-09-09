Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509AbaIIDZl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 23:25:41 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:36429 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754939AbaIIDZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 23:25:38 -0400
Date: Tue, 9 Sep 2014 12:25:29 +0900
From: Tejun Heo <tj@kernel.org>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: Lennart Poettering <lennart@poettering.net>, Kay Sievers <kay@vrfy.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Wu Zhangjin <falcon@meizu.com>, Takashi Iwai <tiwai@suse.de>,
        Arjan van de Ven <arjan@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, hare@suse.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Joseph Salisbury <joseph.salisbury@canonical.com>,
        Benjamin Poirier <bpoirier@suse.de>,
        Santosh Rastapur <santosh@chelsio.com>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Tim Gardner <tim.gardner@canonical.com>,
        Pierre Fersing <pierre-fersing@pierref.org>,
        Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>,
        Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>,
        Sreekanth Reddy <sreekanth.reddy@avagotech.com>,
        Abhijit Mahajan <abhijit.mahajan@avagotech.com>,
        Casey Leedom <leedom@chelsio.com>,
        Hariprasad S <hariprasad@chelsio.com>,
        MPT-FusionLinux.pdl@avagotech.com,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [RFC v2 3/6] kthread: warn on kill signal if not OOM
Message-ID: <20140909032529.GJ11706@mtj.dyndns.org>
References: <20140909012227.GE11706@mtj.dyndns.org>
 <CAB=NE6Vn3hA_VKJyi4kgMi6iMtTtA104-_UfFm6vgX14RoDOTw@mail.gmail.com>
 <20140909012933.GF11706@mtj.dyndns.org>
 <CAB=NE6V+of_RLQtjFpkLN49nKgfONx0T4cbu8kkNU69tUyNozw@mail.gmail.com>
 <20140909014754.GG11706@mtj.dyndns.org>
 <CAB=NE6VAe_96dezJmdXkOjy8mSz8EABX6i8C46GzUJRC-HLAZQ@mail.gmail.com>
 <20140909023943.GH11706@mtj.dyndns.org>
 <CAB=NE6XH64QLfwoE3r7uf3SYKNJMzP-tjUkrxDwVca7G2zOxBQ@mail.gmail.com>
 <20140909030353.GI11706@mtj.dyndns.org>
 <CAB=NE6UGNC7VHnkuv8huaVHLX3Kuh2kOTK92SCw07ehJ3LdXFg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAB=NE6UGNC7VHnkuv8huaVHLX3Kuh2kOTK92SCw07ehJ3LdXFg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Sep 08, 2014 at 08:19:12PM -0700, Luis R. Rodriguez wrote:
> On the systemd side of things it should enable this sysctl and for
> older kernels what should it do?

Supposing the change is backported via -stable, it can try to set the
sysctl on all kernels.  If the knob doesn't exist, the fix is not
there and nothing can be done about it.

Thanks.

-- 
tejun
