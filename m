Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753029Ab3LJSzO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 13:55:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50648 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751080Ab3LJSzL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 13:55:11 -0500
Message-ID: <52A76348.5080803@zytor.com>
Date: Tue, 10 Dec 2013 10:54:00 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Kees Cook <keescook@chromium.org>, LKML <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Rob Landley <rob@landley.net>, Eric Biederman <ebiederm@xmission.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Mel Gorman <mgorman@suse.de>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        kexec@lists.infradead.org
Subject: Re: [PATCH v2] kexec: add sysctl to disable kexec
References: <20131210001620.GA7938@www.outflux.net> <52A66190.9060907@zytor.com> <CAGXu5jKkCNWQKH-Ozm72C3aY_NBzRdNo2GmqKbVVJds5xs=SXg@mail.gmail.com> <20131210143540.GA13909@redhat.com> <f4fbae55-7d7b-400d-b50f-258002371368@email.android.com> <20131210183352.GD13909@redhat.com>
In-Reply-To: <20131210183352.GD13909@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2013 10:33 AM, Vivek Goyal wrote:
> On Tue, Dec 10, 2013 at 08:32:38AM -0800, H. Peter Anvin wrote:
>> Of course it isn't.
> 
> I am not sure what are you trying to say. This is too brief.
> 
> Thanks
> Vivek
> 

Of course it is not sufficient.  Once you can get arbitrary code into
kernel space (CPL 0) you can do anything, and "disabling jump back" is
just a speed bump.

	-hpa


