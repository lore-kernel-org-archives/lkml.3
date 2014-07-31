Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265AbaGaRWP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 13:22:15 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:64242 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639AbaGaRWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 13:22:13 -0400
MIME-Version: 1.0
In-Reply-To: <20140731171017.GA16455@infradead.org>
References: <1406584299.2970.924.camel@schen9-DESK>
	<20140729141908.GA4464@infradead.org>
	<1406651702.2970.927.camel@schen9-DESK>
	<20140729164951.GA23863@infradead.org>
	<1406678232.2970.943.camel@schen9-DESK>
	<20140730001248.GA32367@infradead.org>
	<1406823230.2970.946.camel@schen9-DESK>
	<CA+55aFzqKyM9_-KZsyABNFZcU3ECPCCFfyHmBrBiDzK3q02gLw@mail.gmail.com>
	<20140731171017.GA16455@infradead.org>
Date: Thu, 31 Jul 2014 10:22:12 -0700
X-Google-Sender-Auth: dm2v8zA2ZLxPSEDpqKA31MpWHnA
Message-ID: <CA+55aFzASLcSv+6FBcfZqYsca2FDdzSKAp8PYDUhqXPz-BNqGQ@mail.gmail.com>
Subject: Re: [Regression 3.16-rc kernel] -55% reduction in throughput for OLTP benchmark
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Tim Chen <tim.c.chen@linux.intel.com>, Al Viro <viro@zeniv.linux.org.uk>,
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

On Thu, Jul 31, 2014 at 10:10 AM, Christoph Hellwig <hch@infradead.org> wrote:
>
> I was going to prepare a pull request with just that patch for you later
> today or early tomorrow.

Ok, that's fine. I don't have anything particularly scary lined up -
and quite frankly, despite the big numbers, this patch doesn't really
count as scary either - so right now I'm still planning to do final
3.16 this Sunday.

A pull request today or tomorrow sounds perfectly fine - a pull
request much closer to release less so.

Thanks,

            Linus
