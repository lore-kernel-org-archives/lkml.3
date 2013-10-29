Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751506Ab3J2FbO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 01:31:14 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:45612 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130Ab3J2FbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 01:31:13 -0400
X-AuditID: 9c93016f-b7cb6ae000000e4c-d3-526f481ff7af
From: Namhyung Kim <namhyung@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Pekka Enberg <penberg@iki.fi>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        hegdevasant@linux.vnet.ibm.com, Ingo Molnar <mingo@redhat.com>,
        anton@redhat.com, systemtap@sourceware.org,
        aravinda@linux.vnet.ibm.com
Subject: Re: [PATCH v4 2/3] Support for perf to probe into SDT markers:
References: <20131023044511.1886.82571.stgit@hemant-fedora>
	<20131023050502.1886.15779.stgit@hemant-fedora>
	<CAOJsxLFKm3TxeTmGjbpr1r4sZ8fHcM481-5BM_Cq0J8hhtvBqQ@mail.gmail.com>
	<526E4940.8000608@hitachi.com> <526E5BA5.7050103@iki.fi>
	<20131028141152.GA1040@linux.vnet.ibm.com> <526E72EC.9060400@iki.fi>
	<20131028173152.GB1040@linux.vnet.ibm.com> <526EA366.4020204@iki.fi>
	<526F2949.5000208@hitachi.com>
Date: Tue, 29 Oct 2013 14:31:11 +0900
In-Reply-To: <526F2949.5000208@hitachi.com> (Masami Hiramatsu's message of
	"Tue, 29 Oct 2013 12:19:37 +0900")
Message-ID: <877gcw7ie8.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Masami,

On Tue, 29 Oct 2013 12:19:37 +0900, Masami Hiramatsu wrote:
> (2013/10/29 2:48), Pekka Enberg wrote:
>> For the 32-bit and 64-bit libc case, why cannot 'perf list'
>> by default print out something like:
>> 
>> $ perf list
>> 
>>    libc:setjmp [SDT marker group]
>> 
>> and provide a '--fully-qualified' command line option that:
>> 
>> $ perf list --fully-qualified
>> 
>> libc:setjmp => libc32:setjmp, libc64:setjmp      [SDT marker group]
>> libc32:setjmp => libc:setjmp@/lib/libc.so.6      [SDT marker]
>> libc64:setjmp => libc:setjmp@/lib64/libc.so.6  [SDT marker]
>> 
>> and then teach 'perf trace' to deal with SDT marker groups
>> where you trace two events, not one?
>
> Ah, that's a good idea. :)
> And it also is needed for another probe event because
> sometimes inlined functions have multiple instances.
> I'd like to fold them as one event group.

Yes, I'd love to see it as well. :)

Thanks,
Namhyung
