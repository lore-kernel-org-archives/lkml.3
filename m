Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757996Ab3J2Cvv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 22:51:51 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:57522 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753687Ab3J2Cvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 22:51:50 -0400
Message-ID: <526F22C2.2070403@hitachi.com>
Date: Tue, 29 Oct 2013 11:51:46 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Pekka Enberg <penberg@iki.fi>, Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        hegdevasant@linux.vnet.ibm.com, Ingo Molnar <mingo@redhat.com>,
        anton@redhat.com, systemtap@sourceware.org,
        Namhyung Kim <namhyung@kernel.org>, aravinda@linux.vnet.ibm.com
Subject: Re: Re: [PATCH v4 2/3] Support for perf to probe into SDT markers:
References: <20131023044511.1886.82571.stgit@hemant-fedora> <20131023050502.1886.15779.stgit@hemant-fedora> <CAOJsxLFKm3TxeTmGjbpr1r4sZ8fHcM481-5BM_Cq0J8hhtvBqQ@mail.gmail.com> <526E4940.8000608@hitachi.com> <526E5BA5.7050103@iki.fi> <20131028141152.GA1040@linux.vnet.ibm.com> <526E72EC.9060400@iki.fi> <20131028173152.GB1040@linux.vnet.ibm.com>
In-Reply-To: <20131028173152.GB1040@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/10/29 2:31), Srikar Dronamraju wrote:
>>>
>>> But what if a system has both 32 bit libc and 64 bit libc?
>>> Wont we could end up with 2 libc:setjmp?
>>> Should we give some more intelligence into perf to choose the 64 bit
>>> libc over 32 bit one?
>>
>> You can just trace both of them by default, no?
>>
> 
> There has to be a one to one association with the event name and its
> mapping.  Every event name will finally map to a unique inode and an
> offset.
> 
> One option would be for perf to look at these markers and have a
> different event name for similar markers in different executables. 

Or, another idea is introducing hidden event group which
automatically merges those similar markers and shows
as one event alias name. :)

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


