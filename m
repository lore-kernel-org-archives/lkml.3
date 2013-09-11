Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614Ab3IKDCU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 23:02:20 -0400
Received: from mga02.intel.com ([134.134.136.20]:15724 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752605Ab3IKDCT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 23:02:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,881,1371106800"; 
   d="scan'208";a="376373451"
Message-ID: <522FDD32.9040603@linux.intel.com>
Date: Tue, 10 Sep 2013 20:02:10 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: John Stoffel <john@stoffel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Guenter Roeck <linux@roeck-us.net>, Dave Airlie <airlied@linux.ie>,
        Bruce Fields <bfields@fieldses.org>
Subject: Re: RIP - dead harddisk..
References: <CA+55aFyTpb8k523=qqeO9LMvs6EgmaRdohip0FcTX7Qip1VyxA@mail.gmail.com> <21039.55685.839356.195087@quad.stoffel.home> <CA+55aFymwgUr7y_oMYRahQmtcxFLnE76LhAiD95UxBBEt=WPuA@mail.gmail.com>
In-Reply-To: <CA+55aFymwgUr7y_oMYRahQmtcxFLnE76LhAiD95UxBBEt=WPuA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2013 08:00 PM, Linus Torvalds wrote:
> On Tue, Sep 10, 2013 at 7:46 PM, John Stoffel <john@stoffel.org> wrote:
>>
>> Linus> The timing absolutely sucks, but it looks like the SSD in my
>> Linus> main workstation just died on me.
>>
>> What model, if you care to share?  I figure you'r a perfect storm of
>> SSD beating with all your compiles and git pulls, etc.
> 
> So I don't want to necessarily blame the harddisk, since it's just ten
> days since I upgraded the rest of my machine, after it worked years in
> the previous one. That just makes me go "hmm". As far as I know, all
> the fans etc were working fine, but..
> 
>> And may I suggest that you get TWO of them next time and mirror them,
>> for just this case?  The SysAdmin in my shouting out here...
> 
> I long ago gave up on doing backups. I have actively moved to a model
> where I use replacable machines instead. I've got the stuff I care
> about generally on a couple of different machines, and then keys etc
> backed up on a separate encrypted USB key.
> 
> So it's inconvenient. Mainly from a timing standpoint. But nothing more.
> 

I won't get any stationary machines without mirrored drives anymore.
Storage just isn't reliable enough.

	-hpa


