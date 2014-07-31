Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369AbaGaRI6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 13:08:58 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:40640 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489AbaGaRH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 13:07:56 -0400
MIME-Version: 1.0
In-Reply-To: <1406823230.2970.946.camel@schen9-DESK>
References: <1406584299.2970.924.camel@schen9-DESK>
	<20140729141908.GA4464@infradead.org>
	<1406651702.2970.927.camel@schen9-DESK>
	<20140729164951.GA23863@infradead.org>
	<1406678232.2970.943.camel@schen9-DESK>
	<20140730001248.GA32367@infradead.org>
	<1406823230.2970.946.camel@schen9-DESK>
Date: Thu, 31 Jul 2014 10:07:55 -0700
X-Google-Sender-Auth: cY7orxHFC7dJnvTbDQYtUsaXSgs
Message-ID: <CA+55aFzqKyM9_-KZsyABNFZcU3ECPCCFfyHmBrBiDzK3q02gLw@mail.gmail.com>
Subject: Re: [Regression 3.16-rc kernel] -55% reduction in throughput for OLTP benchmark
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Christoph Hellwig <hch@infradead.org>, Al Viro <viro@zeniv.linux.org.uk>,
        suruchi <suruchi.a.kadu@intel.com>, ak <ak@linux.intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        "hubert.nueckel" <hubert.nueckel@intel.com>,
        beth.marsh-prime@intel.com, "doug.nelson" <doug.nelson@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2014 at 9:13 AM, Tim Chen <tim.c.chen@linux.intel.com> wrote:
> On Tue, 2014-07-29 at 17:12 -0700, Christoph Hellwig wrote:
>>
>> Can I get a tested-by tag from you for the patch?  Can anyone else
>> please cross check it?  The new total value might be different from
>> the old size value when we do a short write, but I can't see how
>> an async write would be a good thing if we had to finish the remainder
>> using buffered I/O if the old code really allowed that.
>>
>
> Yes, please put in
>
> Tested-by: Tim Chen <tim.c.chen@linux.intel.com>
> Tested-by: Suruchi Kadu <suruchi.a.kadu@intel.com>

Ok, good, patch looks fine. Christoph, do you have a commit message for it?

              Linus
