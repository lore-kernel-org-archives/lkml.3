Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756758Ab3J1OVp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 10:21:45 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:42153 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756536Ab3J1OVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 10:21:43 -0400
X-Sasl-enc: 4ixMC0LfZSUT/yJ741IGU/4w4cRG7shmjBuZ3J8Olhu4 1382970094
Message-ID: <526E72EC.9060400@iki.fi>
Date: Mon, 28 Oct 2013 16:21:32 +0200
From: Pekka Enberg <penberg@iki.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
CC: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        hegdevasant@linux.vnet.ibm.com, Ingo Molnar <mingo@redhat.com>,
        anton@redhat.com, systemtap@sourceware.org,
        Namhyung Kim <namhyung@kernel.org>, aravinda@linux.vnet.ibm.com
Subject: Re: [PATCH v4 2/3] Support for perf to probe into SDT markers:
References: <20131023044511.1886.82571.stgit@hemant-fedora> <20131023050502.1886.15779.stgit@hemant-fedora> <CAOJsxLFKm3TxeTmGjbpr1r4sZ8fHcM481-5BM_Cq0J8hhtvBqQ@mail.gmail.com> <526E4940.8000608@hitachi.com> <526E5BA5.7050103@iki.fi> <20131028141152.GA1040@linux.vnet.ibm.com>
In-Reply-To: <20131028141152.GA1040@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/2013 04:11 PM, Srikar Dronamraju wrote:
>
> But what if a system has both 32 bit libc and 64 bit libc?
> Wont we could end up with 2 libc:setjmp?
> Should we give some more intelligence into perf to choose the 64 bit
> libc over 32 bit one?

You can just trace both of them by default, no?

                         Pekka
