Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072AbaFFPlJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 11:41:09 -0400
Received: from smtp103.biz.mail.gq1.yahoo.com ([98.137.12.178]:34344 "HELO
	smtp103.biz.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751460AbaFFPlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 11:41:07 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: Aj24HeAVM1kA1CqEJY8MLox14Ngu8UHivoNCaxUDh01g6zb
 xWrr3yhB8AxSM4PzJzGBMX67ZzHwYQl45qpmPR2fOeq4AEnetwhV6lpGTc_a
 pSMyOGAKeB_Cy93phsw2fge0JNaUTkfdKqOdxtoqfNC4HHy.ZecKvvguc86o
 xJrQ4r9r_tbefxL5rK1R6mS2PylVsZNs4ZJRJge9mG6NEt.wiO5koTsl7igo
 k_XasIGvGxJuFCLjYeaU7ZMtsgmxvBD0pzRBJhze.oc3QEJ61YajMYHZ.Zld
 Vnmhlvlx1L34vL.nNZxj3NV8.sgkz59pmOdw4A06UsHiaH3IOvzsgsnaIxPC
 6geuK2unhJQ76Pw4TintxhtpdhnqB5RLO8S1PCj4AvIjSvqHnyA4hAOgQMJ3
 Iu1a7bnGzPveCcLCHCcOHtnnuVQd8yoOgK9mORUEpCPk2GGDZ39ArBQ6Wrf6
 x2FZ2pPDDCIZNxKQ4V2stPnIY4jKjdiobRZsfFedOC9I7afoq9nvLBbOHYMp
 YWc.V2evvBpnvw3ar_9xVgOfw7pCAVWQpwAqCEf9L4ssWmH4gT.DqIB9tQ.T
 lBTdW0joGzdLZnHUXq9sI64icGc.l3gDsbSpBFkqAXd.XfxAArfCAZeL3ZWj
 3CTSydEZPBbOTkAwG259lxEag7qqGx7.3borjOvYZSkSjOoQvznsOf0cK12n
 rh4ke8g.oqh3M3joYhlEJ1Bfqc4AuuIxW7QSr.CXlnB_Yv0FEtW0IdoL9QHf
 N.g0OIJTlYtQeGMIbhQ--
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-Rocket-Received: from [192.168.0.105] (casey@67.180.103.242 with plain [208.71.40.208])
        by smtp103.biz.mail.gq1.yahoo.com with SMTP; 06 Jun 2014 08:41:06 -0700 PDT
Message-ID: <5391E113.9010909@schaufler-ca.com>
Date: Fri, 06 Jun 2014 08:41:07 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: "Serge E. Hallyn" <serge@hallyn.com>
CC: Serge Hallyn <serge.hallyn@ubuntu.com>,
        Greg KH <gregkh@linuxfoundation.org>, Paul Moore <paul@paul-moore.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        "Serge E. Hallyn" <serge@canonical.com>,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: Change in security maintainer for a few weeks
References: <20140605183050.GA5054@kroah.com> <alpine.LRH.2.00.1406052355500.2434@twin.jikos.cz> <4426926.gIRHbeKnmD@sifl> <20140605225311.GB32470@kroah.com> <20140606044201.GG22106@ubuntumail> <5391D95B.5020408@schaufler-ca.com> <20140606152325.GB28251@mail.hallyn.com>
In-Reply-To: <20140606152325.GB28251@mail.hallyn.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/6/2014 8:23 AM, Serge E. Hallyn wrote:
> Quoting Casey Schaufler (casey@schaufler-ca.com):
>> On 6/5/2014 9:42 PM, Serge Hallyn wrote:
>>> Quoting Greg KH (gregkh@linuxfoundation.org):
>>>> On Thu, Jun 05, 2014 at 06:39:09PM -0400, Paul Moore wrote:
>>>>> On Thursday, June 05, 2014 11:59:11 PM Jiri Kosina wrote:
>>>>>> On Thu, 5 Jun 2014, Greg KH wrote:
>>>>>>> James has had to step back from doing kernel work for a few weeks, so
>>>>>>> I've offered to step up and handle the security patches to get shuttled
>>>>>>> to Linus for merging for a while.
>>>>>> As exactly this (working with active contributors to help co-maintain the
>>>>>> subsystem) has been brought at the ksummit maling list, I am just curious
>>>>>> whether noone else actively working in that area was willing to step up?
>>>>>>
>>>>>> 	$ ./scripts/get_maintainer.pl --git -f security/
>>>>>> 	James Morris <james.l.morris@oracle.com> (supporter:SECURITY SUBSYSTEM)
>>>>>>    ...
>>>>>>
>>>>>> If not, then I think this can be shown as a prime example why the problem
>>>>>> of "non-substituability" of many maintainers is actually real.
>>>>> Once several of us became aware that James was stepping away for a few weeks 
>>>>> (I should mention this was not a planned absence and took most of us by 
>>>>> surprise) we had a brief discussion off-list and several of us did offer to 
>>>>> "step-up"; Serge had already created a repo and since he had pushed patches 
>>>>> while James was away in the past it seemed a reasonable approach this time 
>>>>> around.
>>>> That's great, as the communication around this has not been very much
>>>> (an non-existant on the subsystem mailing list) I was not aware of it.
>>>>
>>>> If Serge wants to do this, and as he has been the stand-in for James in
>>>> the past, I have _no_ objection to this at all.
>>>>
>>>> Serge, feel free to resend your patches to Linus if he doesn't pick them
>>>> up in a few days, with the information that you are doing this in
>>>> James's absence for a while.
>>> Will do (and wil cc: lsm).
>>>
>>>> So, that was easy, I don't have to do this at all, great.
>>>>
>>>> greg k-h
>> How can I verify that the pull James accepted from me is
>> moving forward somehow? Or, if it isn't, where does it go now?
> You can see it at
> https://git.kernel.org/cgit/linux/kernel/git/sergeh/linux-security.git/log/security/smack?h=serge-next-1
> As Greg suggested if Linus doesn't pull it in a few days I will resend
> the pull request.
>
Looks great. Thanks.

