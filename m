Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846Ab3ETK0y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 06:26:54 -0400
Received: from intranet.asianux.com ([58.214.24.6]:3154 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108Ab3ETK0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 06:26:53 -0400
X-Spam-Score: -100.8
Message-ID: <5199FA3B.7060201@asianux.com>
Date: Mon, 20 May 2013 18:26:03 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: james.l.morris@oracle.com, Rusty Russell <rusty@rustcorp.com.au>,
        dmitry.kasatkin@intel.com, andriy.shevchenko@linux.intel.com,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] lib/mpi/mpicoder.c: looping issue, need stop when equal
 to zero, found by 'EXTRA_FLAGS=-W'.
References: <5199AFC9.8050607@asianux.com> <14484.1369044797@warthog.procyon.org.uk>
In-Reply-To: <14484.1369044797@warthog.procyon.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20/2013 06:13 PM, David Howells wrote:
> Chen Gang <gang.chen@asianux.com> wrote:
> 
>> > For 'while' looping, need stop when 'nbytes == 0', or will cause issue.
>> > ('nbytes' is size_t which is always bigger or equal than zero).
>> > 
>> > The related warning: (with EXTRA_CFLAGS=-W)
>> >   lib/mpi/mpicoder.c:40:2: warning: comparison of unsigned expression >= 0 is always true [-Wtype-limits]
> Acked-by: David Howells <dhowells@redhat.com>
> 
> 

Thank you very much.


Thanks.
-- 
Chen Gang

Asianux Corporation
