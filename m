Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933453Ab3CSRyS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 13:54:18 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:32952 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933011Ab3CSRyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 13:54:17 -0400
MIME-Version: 1.0
In-Reply-To: <1363713282.2781.2.camel@buesod1.americas.hpqcorp.net>
References: <1363648854.1774.16.camel@buesod1.americas.hpqcorp.net>
	<CAKocOOOj80R2nP+B_k=jTS-UgA27VvMa-kAFiJbORZg4pKRS1Q@mail.gmail.com>
	<1363713282.2781.2.camel@buesod1.americas.hpqcorp.net>
Date: Tue, 19 Mar 2013 11:54:13 -0600
Message-ID: <CAKocOOM8WeEgDdk6gkKCxLZFgdX8=+-e2zK0qOGmxxfS2qc4bw@mail.gmail.com>
Subject: Re: [PATCH 1/3] rbtree_test: use pr_info for module prefix in messages
From: Shuah Khan <shuahkhan@gmail.com>
To: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 19, 2013 at 11:14 AM, Davidlohr Bueso
<davidlohr.bueso@hp.com> wrote:
> On Tue, 2013-03-19 at 10:29 -0600, Shuah Khan wrote:
>> On Mon, Mar 18, 2013 at 5:20 PM, Davidlohr Bueso <davidlohr.bueso@hp.com> wrote:
>> > This provides nicer message output. Since it seems more appropriate
>> > for the nature of this module, also use KERN_INFO instead of other
>> > levels.
>>
>> Why are you changing the ALERTs to INFO?
>
> Because of the nature of the messages. They don't justify having a
> KERN_ALERT level (requiring immediate attention), and it seems a lot
> more suitable to use INFO instead.
>

Hmm. I see interval_tree_test using the same alerts. It almost looks
like the start and end of a test are meant to be alerts. I am not
saying it shouldn't be changed, however looking for a stronger reason
than "it seems a lot more suitable to use INFO instead". Are there any
use-cases in which KERN_ALERTs cause problems?

-- Shuah
