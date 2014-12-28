Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751943AbaL1SR2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 13:17:28 -0500
Received: from mail-la0-f44.google.com ([209.85.215.44]:55705 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758AbaL1SRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 13:17:24 -0500
MIME-Version: 1.0
In-Reply-To: <20141226170222.GI11609@linux.vnet.ibm.com>
References: <20141214175747.2e6c506e@canb.auug.org.au> <CALCETrXu19aHhudTfPAr5PM05FR0xKBiSHgbubVhh6QUrHCADw@mail.gmail.com>
 <20141214120318.GA5310@linux.vnet.ibm.com> <CALCETrWsy5sxVTmjNu7t+o-QvEVY-csQHkP-PXT1aMFiXnzzhQ@mail.gmail.com>
 <20141214173715.GB5310@linux.vnet.ibm.com> <CALCETrWT7SLO3E+nV2g=QzJHAeWU4FBRENq=7OvoNDrHA7W0fg@mail.gmail.com>
 <20141214181744.GF5310@linux.vnet.ibm.com> <CALCETrXfc5SpjOUfRuj7d5Kzushjucw-njcGT+XW6L26c3BFyA@mail.gmail.com>
 <20141226123336.30fba599@canb.auug.org.au> <20141226170222.GI11609@linux.vnet.ibm.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sun, 28 Dec 2014 10:17:01 -0800
Message-ID: <CALCETrXMDG81oFH0DujSCvxNaAE5YUMEPPGtYupaBck8GQk4Kw@mail.gmail.com>
Subject: Re: linux-next: question about the luto-misc tree
To: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 26, 2014 at 9:02 AM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> On Fri, Dec 26, 2014 at 12:33:36PM +1100, Stephen Rothwell wrote:
>> Hi Andy,
>>
>> On Mon, 22 Dec 2014 11:16:56 -0800 Andy Lutomirski <luto@amacapital.net> wrote:
>> >
>> > I'm re-adding the branch, since 3.19-rc1 is out, the change appears to
>> > still exist as-is in your tree, and it merges cleanly and builds in
>> > the latest -next for me.  Let me know if this will be problematic for
>> > any reason.
>>
>> So, now we have a problem because Paul has rebased a whole set of
>> commits that you have in your tree.  Commits c6dc129cf2d1 to
>> f58d100f65ae in your tree Paul has rebased on top of v3.19-rc1.  If you
>> are going to base your tree on (part of) Paul's tree, then Paul has to
>> agree to not rebase that part of his tree or you have to keep a watch
>> on his tree and rebase you tree on top of those rebased commits.
>> Really, the first should happen.
>
> Apologies, Stephen -- I do seem to be your problem child at the moment!
>
> The desried commit is "rcu: Make rcu_nmi_enter() handle nesting", correct?
> Once confirmed or corrected, I will place this commit at the base of my
> 3.20 tree, which will rebase it one last time, then avoid rebasing it
> in the future, at least assuming no more bugs in that particular commit.
>

Sorry for responding out of order and in HTML.  I just got back from a
couple of days in the wilderness, and I'm catching up out of order.

I've dropped this from my tree for now.  Paul, when you've done the
final rebase, can you let me know?

Thanks,
Andy

>                                                         Thanx, Paul
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
