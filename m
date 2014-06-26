Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184AbaFZHpK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 03:45:10 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:55491 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755025AbaFZHpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 03:45:07 -0400
Message-ID: <311A91BAC7AE49F6B036272FB4A686C4@local.st.by>
From: "Victor Miasnikov" <vvm@tut.by>
To: "Greg KH" <gregkh@linuxfoundation.org>, "Dexuan Cui" <decui@microsoft.com>
Cc: <linux-fbdev@vger.kernel.org>, <jasowang@redhat.com>,
        <driverdev-devel@linuxdriverproject.org>,
        <linux-kernel@vger.kernel.org>, <tomi.valkeinen@ti.com>,
        <olaf@aepfle.de>, "\"Andy Whitcroft\"" <apw@canonical.com>,
        <plagnioj@jcrosoft.com>, "Haiyang Zhang" <haiyangz@microsoft.com>
References: <1403569757-2622-1-git-send-email-decui@microsoft.com> <20140624135101.GB10115@kroah.com> <EE124450C0AAF944A40DD71E61F878C98353C6@SINEX14MBXC418.southpacific.corp.microsoft.com> <20140626033608.GA32654@kroah.com>
Subject: search by phrase a-la "MS-TFS: 157532" -- "has relevance for Hyper-V sysadmins" Re: [PATCH] video: hyperv: hyperv_fb: refresh the VM screen by force on VM panic
Date: Thu, 26 Jun 2014 10:45:01 +0300
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.3790.4548
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.4913
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

 Short:

 1)
greg k-h> don't add marker lines like this that provide no relevancy to anyone else.

 "no relevancy to anyone else" -- strange: it "has relevance for Hyper-V sysadmins"
For search by keywords in web archives of this mail list

 1b)

greg k-h> If you want to refer to a public bug tracker,
greg k-h> that's great
 
 Yes: public bug tracker are welcom


 Full:

D.C>>>>
D.C>>>> MS-TFS: 157532
D.C>>>>

Greg K-h>>>
Greg K-h>>> What is this line for?
Greg K-h>>>

D.C.>> This line is for our internal bug repository.
D.C.>>
D.C.>> The MS-TFS line has appeared in the commit description for a while if you
D.C.>> search for it in 'git log'  of linux-next.
D.C.>>

greg k-h>
greg k-h> Please
greg k-h> don't add marker lines like this that provide no relevancy to anyone else.

 "no relevancy to anyone else" -- strange: it "has relevance for Hyper-V sysadmins"

For search by keywords in web archives of this mail list

 See example:
Results of search sesssion by phrase "MS-TFS: 157532" :
==
LKML: Dexuan Cui: RE: [PATCH] video: hyperv: hyperv_fb ...
lkml.org/lkml/2014/6/24/844
1 day ago - MS-TFS: 157532 > What is this line for? Hi Greg, This line is for our internal bug repository. We have an 
automated system to correlate bugs ...
==
 +
==
[PATCH] video: hyperv: hyperv_fb: refresh the VM screen by force ...
www.gossamer-threads.com/lists/linux/kernel/1952989
5 hours ago - the VSC flushes any future framebuffer change to the VSP immediately. 
MS-TFS: 157532. Signed-off-by: Dexuan Cui
==


greg k-h> I don't allow gerrit ids for the same reason.
greg k-h> If you want to refer to a public bug tracker,
greg k-h> that's great

 
 Yes: public bug tracker are welcom


greg k-h>, otherwise, don't include it.




Best regards, Victor Miasnikov
Blog:  http://vvm.blog.tut.by/


----- Original Message ----- 
From: "Greg KH"
To: "Dexuan Cui"
Cc: . . .
Sent: Thursday, June 26, 2014 6:36 AM
Subject: Re: [PATCH] video: hyperv: hyperv_fb: refresh the VM screen by force on VM panic

On Tue, Jun 24, 2014 at 09:44:14PM +0000, Dexuan Cui wrote:
> >On Tue, Jun 24, 2014 at 08:29:17AM +0800, Dexuan Cui wrote:
> >> Currently the VSC has no chance to notify the VSP of the dirty rectangle on VM
> >> panic because the notification work is done in a workqueue, and in panic() the
> >> kernel typically ends up in an infinite loop, and a typical kernel config has
> >> CONFIG_PREEMPT_VOLUNTARY=y and CONFIG_PREEMPT is not set, so a context switch
> >> can't happen in panic() and the workqueue won't have a chance to run. As a
> >> result, the VM Connection window can't refresh until it's closed and we
> >> re-connect to the VM.
> >>
> >> We can register a handler on panic_notifier_list: the handler can notify
> >> the VSC and switch the framebuffer driver to a "synchronous mode", meaning
> >> the VSC flushes any future framebuffer change to the VSP immediately.
> >>
> >> MS-TFS: 157532
>
> > What is this line for?
>
> Hi Greg,
> This line is for our internal bug repository.
> We have an automated system to correlate bugs with fixes so that our test
> team knows when a bug fix has been accepted upstream and they need to
> write a new test case for it.
>
> The MS-TFS line has appeared in the commit description for a while if you
> search for it in 'git log'  of linux-next.
>
> Please let us know if you have further comments.

Please don't add marker lines like this that provide no relevancy to
anyone else.  I don't allow gerrit ids for the same reason.  If you want
to refer to a public bug tracker, that's great, otherwise, don't
include it.

greg k-h
--

