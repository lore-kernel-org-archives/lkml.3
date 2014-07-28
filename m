Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704AbaG1PBr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 11:01:47 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:47270 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753098AbaG1PBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 11:01:44 -0400
MIME-Version: 1.0
In-Reply-To: <s5h4my1wn8k.wl%tiwai@suse.de>
References: <1406558067-25308-1-git-send-email-mcgrof@do-not-panic.com> <s5h4my1wn8k.wl%tiwai@suse.de>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Mon, 28 Jul 2014 08:01:22 -0700
X-Google-Sender-Auth: UWTOk9uXsO6nWlmFny9j44ZYOlI
Message-ID: <CAB=NE6Ufgb=N=uZ3Q4HRaz0k+00c4w06L7e5c4RRo5WJxbCX_g@mail.gmail.com>
Subject: Re: [PATCH 1/3] driver core: enable drivers to use deferred probe
 from init
To: Takashi Iwai <tiwai@suse.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Joseph Salisbury <joseph.salisbury@canonical.com>,
        Kay Sievers <kay@vrfy.org>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Tim Gardner <tim.gardner@canonical.com>,
        Pierre Fersing <pierre-fersing@pierref.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Benjamin Poirier <bpoirier@suse.de>,
        Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>,
        Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>,
        Sreekanth Reddy <sreekanth.reddy@avagotech.com>,
        Abhijit Mahajan <abhijit.mahajan@avagotech.com>,
        Hariprasad S <hariprasad@chelsio.com>,
        Santosh Rastapur <santosh@chelsio.com>,
        MPT-FusionLinux.pdl@avagotech.com,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2014 at 7:51 AM, Takashi Iwai <tiwai@suse.de> wrote:
>
> This field isn't used anywhere actually in the patch...?

Yeah sorry that is not needed, I avoided that by adding the simple
bool on the struct device, forgot to nuke that. Will spin v2 unless I
hear otherwise.

 Luis
