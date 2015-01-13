Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598AbbAMP4d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 10:56:33 -0500
Received: from mail.emea.novell.com ([130.57.118.101]:33409 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331AbbAMP4c convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Tue, 13 Jan 2015 10:56:32 -0500
Message-Id: <54B54E3C0200007800054741@mail.emea.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.1 
Date: Tue, 13 Jan 2015 15:56:28 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Arnaldo Carvalho de Melo" <acme@redhat.com>
Cc: "Arnaldo Carvalho de Melo" <acme@kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: your recent tools/include/ adjustments
References: <54B4E9F3020000780005427E@mail.emea.novell.com>
 <20150113132912.GA2468@redhat.com>
In-Reply-To: <20150113132912.GA2468@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 13.01.15 at 14:29, <acme@redhat.com> wrote:
> Em Tue, Jan 13, 2015 at 08:48:35AM +0000, Jan Beulich escreveu:
>> Arnaldo,
>> 
>> considering that tools/include/ gets used by other than just perf, in
>> particular arch/x86/vdso/vdso2c.c, would you mind clarifying how
>> "tools: Move bitops.h from tools/perf/util to tools/" adding an
>> inclusion of asm/hweight.h to linux/bitops.h is supposed to work,
>> when the only potentially relevant header to be found is
>> tools/perf/util/include/asm/hweight.h?
> 
> Oops, includes are tricky, even more so when trying to reuse the kernel
> ones in tools/, so we need to go on addressing these problems, thanks
> for reporting.
> 
> Please take a look if the patch at the end addresses this problem, I
> think it should at least disentangle what is in tools/include from what
> is in tools/perf/.

It looks like it would fix the issue - thanks for the quick response.

Jan

