Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755115AbaCZOvk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 10:51:40 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:39456 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754868AbaCZOvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 10:51:38 -0400
Message-ID: <5332E977.8010102@suse.cz>
Date: Wed, 26 Mar 2014 15:51:35 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Josh Boyer <jwboyer@fedoraproject.org>, Greg KH <greg@kroah.com>,
        mhocko@suse.cz
CC: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Kernel Fedora <kernel@lists.fedoraproject.org>
Subject: Re: Feb. Fedora Kernel Patch Report
References: <CA+5PVA6dz2ixLfHOHytkis6XmxdLKXZp9x8rEjB=pedrg7sXJQ@mail.gmail.com>	<20140325212417.GA6545@kroah.com> <CA+5PVA608SPM1r5tXwo_C+vaEff+XiLQ5AWwH7-i-MMGcXtuHw@mail.gmail.com>
In-Reply-To: <CA+5PVA608SPM1r5tXwo_C+vaEff+XiLQ5AWwH7-i-MMGcXtuHw@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26/2014 02:44 PM, Josh Boyer wrote:
> On Tue, Mar 25, 2014 at 5:24 PM, Greg KH <greg@kroah.com> wrote:
>> On Fri, Feb 28, 2014 at 10:13:29AM -0500, Josh Boyer wrote:
>>> cgroup-fixes.patch (rhbz 1045755)
>>> - Upstream commits 0ab02ca8f887908152d1a96db5130fc661d36a1e
>>> - There was a 3.12 version of this patch sent to stable list from
>>> Michal Hocko.  I don't remember why it wasn't applied, or why it
>>> wasn't applied for 3.13.y...
>>
>> It didn't apply to 3.13, and I think I was waiting for a backported
>> version, do you have one?
> 
> As far as I know we're using this version:
> 
> http://thread.gmane.org/gmane.linux.kernel.cgroups/10336/focus=1646465
> 
> The commentary on the thread seems to imply that Michal was going to
> send it again for some reason.  Michal, did you send the 3.12/3.13
> backport for this commit directly to stable?

In the meantime, I applied to the stable 3.12 Michal's version from suse
enterprise 12. I believe that it is the same as in the link above.
Please confirm.

thanks,
-- 
js
suse labs
