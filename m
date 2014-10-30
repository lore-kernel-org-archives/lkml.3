Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758735AbaJ3JCV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 05:02:21 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:44234 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754839AbaJ3JCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 05:02:17 -0400
MIME-Version: 1.0
In-Reply-To: <1414619976.2542.1.camel@perches.com>
References: <54515a25.46WrYSce5BExT3V4%akpm@linux-foundation.org>
	<alpine.DEB.2.11.1410292233340.5308@nanos>
	<1414619976.2542.1.camel@perches.com>
Date: Thu, 30 Oct 2014 10:02:15 +0100
Message-ID: <CAFLxGvwGRz8Z2=eD53VjVgUf5zdM3KCyLcUZN1g_Po2D2xQ4DA@mail.gmail.com>
Subject: Re: mmotm 2014-10-29-14-19 uploaded
From: Richard Weinberger <richard.weinberger@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        mm-commits@vger.kernel.org, "linux-mm@kvack.org" <linux-mm@kvack.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-next@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Michal Hocko <mhocko@suse.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 10:59 PM, Joe Perches <joe@perches.com> wrote:
> On Wed, 2014-10-29 at 22:37 +0100, Thomas Gleixner wrote:
>> On Wed, 29 Oct 2014, akpm@linux-foundation.org wrote:
>> > This mmotm tree contains the following patches against 3.18-rc2:
>> > (patches marked "*" will be included in linux-next)
>> >
>> > * kernel-posix-timersc-code-clean-up.patch
>>
>> Can you please drop this pointless churn? We really can replace all
>> that stuff with a shell script and let it run over the tree every now
>> and then.
>
> Should any automated code reformatting really be done
> by an unsupervised or unreviewed shell script?

As many users of "checkpatch.pl -f" behave anyway like
unsupervised/unreviewed shell scripts
it would not matter. ;-)

-- 
Thanks,
//richard
