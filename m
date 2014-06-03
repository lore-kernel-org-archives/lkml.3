Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386AbaFCRw4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 13:52:56 -0400
Received: from mail-qg0-f51.google.com ([209.85.192.51]:40064 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307AbaFCRwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 13:52:55 -0400
Date: Tue, 3 Jun 2014 13:52:51 -0400
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Li Zefan <lizefan@huawei.com>, Andy Lutomirski <luto@amacapital.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jianyu Zhan <nasa4836@gmail.com>
Subject: Re: 3.15 regression: wrong cgroup magic
Message-ID: <20140603175251.GF26210@htj.dyndns.org>
References: <CALCETrXbpiqwY=qyPcNWn2zX=vehXzBbxDG725egM9T2Ox2KTA@mail.gmail.com>
 <538D2261.70406@huawei.com>
 <20140603012211.GE19855@htj.dyndns.org>
 <CA+55aFx=TG25jPohWZ5xbYs4DcOTUQnCPA8G_fZZouNEfSoZ3A@mail.gmail.com>
 <CA+55aFxfEsOZreYBCrDTfgaSf0441zXf4uSmzsYU-JXHBRkzJg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxfEsOZreYBCrDTfgaSf0441zXf4uSmzsYU-JXHBRkzJg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2014 at 10:23:03AM -0700, Linus Torvalds wrote:
> Tejun, just to be anal, can you please test and verify current -git
> (preferably both 'master' and 'next') with your app that cared about
> the f_type information for statfs()..

It was Andy.  Andy, can you please verify the latest -git fixes your
setup?  FWIW, I just verified the reported magic numbers and
everything looks kosher to me.

 # ./fstype / /sys /sys/fs/cgroup/memory/
 f_type=0x0000ef53 /
 f_type=0x62656572 /sys
 f_type=0x0027e0eb /sys/fs/cgroup/memory/

Thanks.

-- 
tejun
