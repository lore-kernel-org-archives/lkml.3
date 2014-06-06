Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123AbaFFPOv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 11:14:51 -0400
Received: from smtp103.biz.mail.gq1.yahoo.com ([98.137.12.178]:25272 "HELO
	smtp103.biz.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751646AbaFFPOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 11:14:50 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Jun 2014 11:14:50 EDT
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: Jgc3JZ4VM1nj_O..iJ3R4hGo2omiq4DiBaxGDfzhIhv2GxU
 e5FIGfS4OC2RZu27EqS61GBwxj5mAxnxMfF59sIh6XSWtqpCB_oLHiUUMwU2
 na.bfrOcYOzibD9pglifjUT7hMC3xVDzKScQacivJNCnPGJZWn6zW7IEJiZm
 ECbXy4V5vKDfp5S0ekz7hDpEc.9WaOXkgfQrGElSWyDZCEm7BKUrpmTPoLVZ
 UZLY5d6qP9.WWtSqZIgGVT0YDO4yt84ruaBkhI873H2b7TS8NtmZH7gpuQR9
 QowQtycyeN4LK3yM1fwJUe8nry.JyItIRvxttpoQUCMS4xQyDrl10LrqwUy_
 u8aVBy0HqdpN6FNl8Blim9L3Rl5MNsDFyOf2g1gm2ULAqHV4v3Z4iO56kdSc
 GNFFxgn10VmEPKsV0GACb2hI3qL7fTA5osLVzqpns98yTlVtqi2cBhrqCwka
 UfS..1qTxd.6_kwZsbEGtDe5IXflPPxrlJ9fuvo57YJIK4ikB1va7hduIXgA
 eHJgxKMdp2fxPluiDqApEZ5GahpEx1NUm0qxoNS0DvL0e2zhBgzUi7Gt_toK
 2PCy0AfQnHfGbJvJN5laPq1N5EqFYamE5kxyPMIFXgvGplmastWidWDBUYBx
 Hgrok8Zg4qPp1c3fjXs5Q3YMd2p47qYNBwW2_HmTHf442rXrTxwWFSiLGIe9
 FyKLqNWE-
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-Rocket-Received: from [192.168.0.105] (casey@67.180.103.242 with plain [208.71.40.208])
        by smtp103.biz.mail.gq1.yahoo.com with SMTP; 06 Jun 2014 08:08:09 -0700 PDT
Message-ID: <5391D95B.5020408@schaufler-ca.com>
Date: Fri, 06 Jun 2014 08:08:11 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Serge Hallyn <serge.hallyn@ubuntu.com>,
        Greg KH <gregkh@linuxfoundation.org>
CC: Paul Moore <paul@paul-moore.com>, Jiri Kosina <jkosina@suse.cz>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        "Serge E. Hallyn" <serge@canonical.com>,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: Change in security maintainer for a few weeks
References: <20140605183050.GA5054@kroah.com> <alpine.LRH.2.00.1406052355500.2434@twin.jikos.cz> <4426926.gIRHbeKnmD@sifl> <20140605225311.GB32470@kroah.com> <20140606044201.GG22106@ubuntumail>
In-Reply-To: <20140606044201.GG22106@ubuntumail>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/5/2014 9:42 PM, Serge Hallyn wrote:
> Quoting Greg KH (gregkh@linuxfoundation.org):
>> On Thu, Jun 05, 2014 at 06:39:09PM -0400, Paul Moore wrote:
>>> On Thursday, June 05, 2014 11:59:11 PM Jiri Kosina wrote:
>>>> On Thu, 5 Jun 2014, Greg KH wrote:
>>>>> James has had to step back from doing kernel work for a few weeks, so
>>>>> I've offered to step up and handle the security patches to get shuttled
>>>>> to Linus for merging for a while.
>>>> As exactly this (working with active contributors to help co-maintain the
>>>> subsystem) has been brought at the ksummit maling list, I am just curious
>>>> whether noone else actively working in that area was willing to step up?
>>>>
>>>> 	$ ./scripts/get_maintainer.pl --git -f security/
>>>> 	James Morris <james.l.morris@oracle.com> (supporter:SECURITY SUBSYSTEM)
>>>>    ...
>>>>
>>>> If not, then I think this can be shown as a prime example why the problem
>>>> of "non-substituability" of many maintainers is actually real.
>>> Once several of us became aware that James was stepping away for a few weeks 
>>> (I should mention this was not a planned absence and took most of us by 
>>> surprise) we had a brief discussion off-list and several of us did offer to 
>>> "step-up"; Serge had already created a repo and since he had pushed patches 
>>> while James was away in the past it seemed a reasonable approach this time 
>>> around.
>> That's great, as the communication around this has not been very much
>> (an non-existant on the subsystem mailing list) I was not aware of it.
>>
>> If Serge wants to do this, and as he has been the stand-in for James in
>> the past, I have _no_ objection to this at all.
>>
>> Serge, feel free to resend your patches to Linus if he doesn't pick them
>> up in a few days, with the information that you are doing this in
>> James's absence for a while.
> Will do (and wil cc: lsm).
>
>> So, that was easy, I don't have to do this at all, great.
>>
>> greg k-h

How can I verify that the pull James accepted from me is
moving forward somehow? Or, if it isn't, where does it go now?


On Thu, 15 May 2014, Casey Schaufler wrote:

> The following changes since commit f64410ec665479d7b4b77b7519e814253ed0f686:
>
>   selinux: correctly label /proc inodes in use before the policy is loaded (2014-03-19 16:46:18 -0400)
>
> are available in the git repository at:
>
>   git://git.gitorious.org/smack-next/kernel.git smack-for-3.16
>
> for you to fetch changes up to ec554fa75ec94dcf47e52db9551755679c10235b:

Thanks, pulled.


-- James Morris <jmorris@namei.org> 

> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

