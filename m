Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614Ab3I0OmD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 10:42:03 -0400
Received: from a14-66.smtp-out.amazonses.com ([54.240.14.66]:49798 "EHLO
	a14-66.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752323Ab3I0OmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 10:42:01 -0400
X-Greylist: delayed 307 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Sep 2013 10:42:01 EDT
Date: Fri, 27 Sep 2013 14:36:53 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Ingo Molnar <mingo@kernel.org>
cc: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org,
        Steven Rostedt <srostedt@redhat.com>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [pchecks v1 4/4] percpu: Add preemption checks to __this_cpu
 ops
In-Reply-To: <20130925182654.GB16693@gmail.com>
Message-ID: <000001415fd9d3d8-7800dc31-9e8f-4981-963c-7d9851dafe75-000000@email.amazonses.com>
References: <20130923191256.584672290@linux.com> <000001414c47a1da-a60858ec-6fe0-4560-a859-8274151411bf-000000@email.amazonses.com> <20130924080347.GH28538@gmail.com> <00000141505b72a3-6935722e-fdfb-4c46-b52c-bc40609144ac-000000@email.amazonses.com>
 <20130924151847.GB8494@gmail.com> <00000141509c4346-586ca654-989b-4a6a-ae30-592d2f8f11a8-000000@email.amazonses.com> <20130924172600.GD10261@gmail.com> <000001415604292f-63d4c50d-23e2-43ea-af60-f0e385c71661-000000@email.amazonses.com>
 <20130925182654.GB16693@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="376175846-1786131042-1380292498=:20929"
Content-ID: <alpine.DEB.2.02.1309270936110.20929@gentwo.org>
X-SES-Outgoing: 2013.09.27-54.240.14.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--376175846-1786131042-1380292498=:20929
Content-Type: TEXT/PLAIN; CHARSET=KOI8-R
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.DEB.2.02.1309270936111.20929@gentwo.org>

On Wed, 25 Sep 2013, Ingo Molnar wrote:

> > And then instead of thanks I get insults sprinkled with some paranoia.
>
> Pointing out your lack of cooperation (such as repeatedly ignoring
> maintainer feedback) is not an "insult" - it's my duty as a maintainer to
> protect other submitters who do their homework and it's also my duty as a
> maintainer to keep crappy patches from entering the kernel. Resisting
> low-quality patches like yours and pointing out patch submission errors
> and inefficiencies is my job.

Thats paranoia. No lack of cooperation. Feedback to patches during
development is normal until they reach proper maturity for merging. Thats
why these things are usually versioned.

> For example lets just take your latest submission from yesterday to see
> sloppiness in action:
>
> 63175   C Sep 24 Christoph Lamet ( 121) ��>[pchecks v2 1/2] Subject; percpu: Add raw_cpu_ops
> 63176   C Sep 24 Christoph Lamet ( 206) ��>[pchecks v2 2/2] percpu: Add preemption checks to __this_cpu ops
> 63178   C Sep 24 Christoph Lamet (  14) [pchecks v2 0/2] percpu v2: Implement Preemption checks for __this_cpu operatio
>
> The 0/2 mail arrived before the 1/2 and 2/2 mails, because you did not use
> git-send-email threading options properly to thread them all together...

"quilt mail" was used for those which provides proper threading AFAICT.
The headers look fine here without the additional "subject: stuff". Wonder
why the 0/2 did not get put the right way.

> If you have limited time to contribute I'd suggest you work on each
> submission a bit more before sending them, to make sure it has the
> expected quality, to make sure you've addressed all review feedback, etc.
> - this will waste less time of everyone involved and will generally result
> in fewer complaints as well.

Certainly I am trying to address all the issues.
--376175846-1786131042-1380292498=:20929--
