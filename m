Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484AbaBLCgR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 21:36:17 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:52506 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919AbaBLCgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 21:36:15 -0500
MIME-Version: 1.0
In-Reply-To: <20140131142442.8030cf06d1d729c8e3a4541c@linux-foundation.org>
References: <1391041675-31683-1-git-send-email-henrik@austad.us>
 <52E9D3EB.1060209@landley.net> <20140131142442.8030cf06d1d729c8e3a4541c@linux-foundation.org>
From: Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Tue, 11 Feb 2014 21:35:43 -0500
X-Google-Sender-Auth: 2eazm3PJ9UZrgffQGf4bRziqptQ
Message-ID: <CAP=VYLqNgsKkn8e7f51H523T6GKhb_q8EhEsUmF3z_M8qR4CMQ@mail.gmail.com>
Subject: Re: [PATCH] Documentation cleanup, update 00-INDEX files in Documentation/
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rob Landley <rob@landley.net>, Henrik Austad <henrik@austad.us>,
        LKML doc <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Kosina <jkosina@suse.cz>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Rob Herring <robh+dt@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Mark Brown <broonie@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>, Gleb Natapov <gleb@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Len Brown <len.brown@intel.com>,
        James Bottomley <JBottomley@parallels.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 31, 2014 at 5:24 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Wed, 29 Jan 2014 22:24:11 -0600 Rob Landley <rob@landley.net> wrote:
>
>> On 01/29/14 18:27, Henrik Austad wrote:
>> > Some of the 00-INDEX files are somewhat outdated and some folders does not
>> > contain 00-INDEX at all. Only outdated (with the notably exception of
>> > spi) indexes are touched here, the 169 folders without 00-INDEX has not
>> > been touched.
>> >
>> > This applies to Linus' tip (0e47c969).
>>
>> Looks like an improvement.
>>
>> Acked-by: Rob Landley <rob@landley.net>
>
> Are these 00-INDEX files actually useful?  I've never opened one of
> them in my life.

I think I introduced them some decades ago, but after a basic search I could
not incriminate myself, so I do ACK the blanket removal -- FWIW.  :)

Paul.
--
