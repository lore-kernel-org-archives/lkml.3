Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754383Ab3J3NaZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 09:30:25 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:44178 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754201Ab3J3NaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 09:30:23 -0400
Message-ID: <527109E3.1020100@linux.vnet.ibm.com>
Date: Wed, 30 Oct 2013 19:00:11 +0530
From: Hemant Kumar <hkshaw@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: "Frank Ch. Eigler" <fche@redhat.com>, Pekka Enberg <penberg@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        hegdevasant@linux.vnet.ibm.com, Ingo Molnar <mingo@redhat.com>,
        anton@redhat.com, systemtap@sourceware.org,
        Namhyung Kim <namhyung@kernel.org>, aravinda@linux.vnet.ibm.com,
        dsahern@gmail.com,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: [PATCH v4 2/3] Support for perf to probe into SDT markers:
References: <20131023044511.1886.82571.stgit@hemant-fedora> <20131023050502.1886.15779.stgit@hemant-fedora> <CAOJsxLFKm3TxeTmGjbpr1r4sZ8fHcM481-5BM_Cq0J8hhtvBqQ@mail.gmail.com> <y0mbo2cs2oa.fsf@fche.csb> <5270D9F7.3090105@hitachi.com>
In-Reply-To: <5270D9F7.3090105@hitachi.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13103013-0260-0000-0000-000003E17E33
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/30/2013 03:35 PM, Masami Hiramatsu wrote:
> (2013/10/26 20:16), Frank Ch. Eigler wrote:
>> Note that a $PATH search excludes shared libraries, which can also
>> carry <sys/sdt.h> markers.  Adding /usr/lib* in more than doubles the
>> work, then there's /usr/libexec etc.
> To find all system libraries, we can use ldconfig.
>
> $ ldconfig --print-cache
>
> shows what dynamic libraries will be loaded. On my own laptop (running
> ubuntu13.04) shows ~1000 libs.
>
> Thank you,
>

Ah! that seems nice... will save a lot of time!

-- 
Thanks
Hemant Kumar

