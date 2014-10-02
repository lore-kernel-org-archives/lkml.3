Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752201AbaJBXbs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 19:31:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46306 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751488AbaJBXbq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 19:31:46 -0400
Date: Fri, 3 Oct 2014 01:31:45 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, gregkh@linuxfoundation.org,
        tiwai@suse.de, tj@kernel.org, arjan@linux.intel.com, teg@jklm.no,
        rmilasan@suse.com, werner@suse.com, oleg@redhat.com, hare@suse.com,
        bpoirier@suse.de, santosh@chelsio.com, pmladek@suse.cz,
        dbueso@suse.com, linux-kernel@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
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
        MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v1 5/5] driver-core: add driver asynchronous probe
	support
Message-ID: <20141002233145.GU14081@wotan.suse.de>
References: <1411768637-6809-1-git-send-email-mcgrof@do-not-panic.com> <1411768637-6809-6-git-send-email-mcgrof@do-not-panic.com> <20140928192247.GA28033@core.coreip.homeip.net> <20140930071555.GB14081@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140930071555.GB14081@wotan.suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2014 at 09:15:55AM +0200, Luis R. Rodriguez wrote:
> Can you provide an example code path hit here? I'll certainly like to address
> that as well.

I managed to enable built-in driver support on top of this series,
I'll send them as part of the next series but I suspect we'll want
to discuss blacklist/whitelist a bit more there.

 Luis
