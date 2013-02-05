Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518Ab3BEN5o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 08:57:44 -0500
Received: from us01smtp2.synopsys.com ([198.182.44.80]:59840 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754018Ab3BEN5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 08:57:41 -0500
Message-ID: <51110F1A.8090606@synopsys.com>
Date: Tue, 5 Feb 2013 19:24:34 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel,gmane.linux.kernel.cross-arch
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Arnd Bergmann <arnd@arndb.de>, James Hogan <james.hogan@imgtec.com>,
        <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>,
        <rkuo@codeaurora.org>
Subject: Re: [PATCH v3 00/44] Meta Linux Kernel Port
References: <1357831872-29451-1-git-send-email-james.hogan@imgtec.com> <5102BB38.3050207@imgtec.com> <201301260025.10020.arnd@arndb.de> <51062460.9060902@synopsys.com> <20130130074452.f67abeeaae3a00d046f5699f@canb.auug.org.au>
In-Reply-To: <20130130074452.f67abeeaae3a00d046f5699f@canb.auug.org.au>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.43]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 January 2013 02:14 AM, Stephen Rothwell wrote:
> Hi Vineet,
> 
> On Mon, 28 Jan 2013 12:40:24 +0530 Vineet Gupta <Vineet.Gupta1@synopsys.com> wrote:
>>
>> Stephen, can you please add the following branch (rebased off 3.8-rc5) to linux-next
>>
>> git://github.com/foss-for-synopsys-dwc-arc-processors/linux.git  arc-next
> 
> Added from today (though there may not be a linux-next release today).

Thanks Stephan - I see it in there for last 2 days now.

>> While the first pull request can go directly from github, I presume the logistics
>> for setting up accounts on kernel.org will only kick start after the first batch
>> of code has been accepted. I can't seem to find any discussions on lists to that
>> effect.
> 
> Linus prefers to not pull from github, but will if you ask him to pull a
> tag signed with a verifiable gpg key.  This is not a requirement if your
> tree is on kernel.org (though you still need a verifiable gpg key to get
> a kernel.org account).

At the moment I don't have my key signed by anyone else. James pointed me to
http://www.kernel.org/signature.html so I've added myself to the google map page
and there's obviously no one near me. So how do we solve this - can I call a
developer - who say trusts me - and get him to sign using my key-id.

Richard I believe you were in a similar situation when submitting your port - how
did you end up solving this.

Damn! I was at ELCE back in November but wasn't aware of need for doing this.

Thx,
-Vineet
