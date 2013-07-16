Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569Ab3GPJ2m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 05:28:42 -0400
Received: from a-pb-sasl-quonix.pobox.com ([208.72.237.25]:64052 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754366Ab3GPJ2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 05:28:40 -0400
X-Greylist: delayed 817 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Jul 2013 05:28:40 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=mime-version
	:in-reply-to:references:date:message-id:subject:from:to:cc
	:content-type; q=dns; s=sasl; b=FVK59BlewQzGAY8lscT3qLlXUvxBlmTV
	/yZL+Er1g8DKk5QhWgYfkL0CM7Y3uyUY5Dv2aLVL2v36cKXYlohLZq9vn540MKaZ
	4Vz7MOKCsjgXSDImVgTsHRDclliAUWeqI0Ab9fL5O1aDjZTC98JVDZsUtlnKTW4T
	LYW1M69dKWw=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1307160025250.16723@nftneq.ynat.uz>
References: <20130715174659.GC15531@xanatos>
	<CA+55aFx4VoYZCEQ97jaAKDWViG1yfu9AikJ4R+dKru-qPVSY-A@mail.gmail.com>
	<20130715180403.GD15531@xanatos>
	<CA+55aFxmV83=_kjsHGbXFwQW9tXdbT6vyEGcuDTC00X0JJvB7w@mail.gmail.com>
	<20130715184642.GE15531@xanatos>
	<CA+55aFx+W9V845zcVrUWXvL=qtYYSX=Tj25d4im4gKV5pHA35Q@mail.gmail.com>
	<20130715195316.GF15531@xanatos>
	<20130715204135.GH15531@xanatos>
	<CA+55aFzwfAkWA6JZruXNKX2=xd-oWM=G8FKhWCVn2xkpR_1sUA@mail.gmail.com>
	<1373926109.17876.221.camel@gandalf.local.home>
	<20130715223615.GI15531@xanatos>
	<alpine.DEB.2.02.1307160025250.16723@nftneq.ynat.uz>
Date: Tue, 16 Jul 2013 11:14:51 +0200
Message-ID: <CAMFK0gseVAyCNwM6+-5ChJP5ReodjBA-estzB0u_pEhk2bAQsw@mail.gmail.com>
Subject: Re: [ATTEND] How to act on LKML (was: [ 00/19] 3.10.1-stable review)
From: Olivier Galibert <galibert@pobox.com>
To: David Lang <david@lang.hm>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>, Darren Hart <dvhart@linux.intel.com>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        Willy Tarreau <w@1wt.eu>
Content-Type: text/plain; charset=ISO-8859-1
X-Pobox-Relay-ID: 2E875174-EDF8-11E2-A225-9E6C0E5B5709-92059326!a-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 9:32 AM, David Lang <david@lang.hm> wrote:
> On Mon, 15 Jul 2013, Sarah Sharp wrote:
>
>> The people who want to work together in a civil manner should get
>> together and create a "Kernel maintainer's code of conduct" that
>> outlines what they expect from fellow kernel developers.  The people who
>> want to continue acting "unprofessionally" should document what
>> behaviors set off their cursing streaks, so that others can avoid that
>> behavior.  Somewhere in the middle is the community behavior all
>> developers can thrive in.
>
>
> By defining your viewpoint as being "professional" and the other viewpoint
> as being "unprofessional" you have already started using very loaded terms
> and greatly reduces the probability of actually getting the other group to
> agree and participate.

Especially since you can very easily translate these terms into
"American" and "non-American".

The stereotypical american professionalism attitude is to be polite at
the word choice level the best to hide a profund disrespect under
them.  There's no meaning taken into account, it's just keyword
spotting.  "Your code is crap" is considered unprofessional, while
"Let's leverage my fifth grade nephew's capabilities to assist you in
fixing the code" is perfectly professional, somehow.  That's more
often than not an unacceptable attitude in europe.

  OG.
