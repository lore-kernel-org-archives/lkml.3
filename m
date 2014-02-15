Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508AbaBOKKb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 05:10:31 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:43489 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413AbaBOKK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 05:10:26 -0500
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <20140214161552.GA20909@infradead.org>
References: <52FE33A0.6090702@gmail.com> <20140214161552.GA20909@infradead.org>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Sat, 15 Feb 2014 11:10:06 +0100
Message-ID: <CAKgNAkht_Lp83QGSXHC9HT31LXoDS9Yjg+s1_xQH8Xmt96mAmw@mail.gmail.com>
Subject: Re: man-pages-3.58 is released
To: Christoph Hellwig <hch@infradead.org>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 14, 2014 at 5:15 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Fri, Feb 14, 2014 at 04:17:52PM +0100, Michael Kerrisk (man-pages) wrote:
>> pipe.2
>>     Michael Kerrisk
>>         Document the pipe2() O_DIRECT flag added in Linux 3.4
>
> Eww, reusing O_DIRECT for some totally different semantics is nasty.
> Did this go by linux-man back in the day?

(I suspect you meant linux-api@)

Nope. I happened to discover the new flag by accident while grepping
the sources.

Cheers,

Michael



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
