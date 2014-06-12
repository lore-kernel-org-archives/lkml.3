Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752348AbaFLSvW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 14:51:22 -0400
Received: from mail-ve0-f178.google.com ([209.85.128.178]:49379 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817AbaFLSvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 14:51:21 -0400
MIME-Version: 1.0
In-Reply-To: <5399F616.2040809@linux.intel.com>
References: <CAKx2Y1kBy-mrxm+1u88XVL2Z7gYKQe5U-EG2SBTzNCRAs_UVVw@mail.gmail.com>
 <CALCETrWMBAxz9yn4MMugjZGC_Dsi2p855+e99Qhr0Ab+OaGRXw@mail.gmail.com>
 <CALCETrWTx5j9mx-CeXJDUAXh8KqVhGqBK+gpOPgJS1hOgH5tmg@mail.gmail.com>
 <5399F445.6060200@linux.intel.com> <CALCETrV96Ry5f_RDvXfZ98ay9qLZw0-8H5LZ8NrPiS92WDWTmA@mail.gmail.com>
 <5399F616.2040809@linux.intel.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 12 Jun 2014 11:51:00 -0700
Message-ID: <CALCETrWyC5B0EgdbxKr_VYN+bARGy55E_p2ppk-gW5sLc5jHWg@mail.gmail.com>
Subject: Re: Segmentation fault on all golang executables
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Kui Zhang <kuizhang@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2014 at 11:48 AM, H. Peter Anvin <hpa@linux.intel.com> wrote:
> On 06/12/2014 11:42 AM, Andy Lutomirski wrote:
>>
>> Note that my hack will build a buggy vdso on big-endian hosts.  Is
>> there a way to convert host -> BE yet?
>>
>
> Yes, use <tools/be_byteshift.h>.

What should I rebase on for that?  And wasn't there some header that
was supposed to choose the right include file given the host runtime?

Also, I meant host -> LE, of course, but that should be trivial.

--Andy

>
>         -hpa
>
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
