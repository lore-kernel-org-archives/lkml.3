Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751588AbaFFFp0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 01:45:26 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:65226 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907AbaFFFpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 01:45:25 -0400
Message-ID: <5391556D.6090204@gmail.com>
Date: Fri, 06 Jun 2014 07:45:17 +0200
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: mtk.manpages@gmail.com, WANG Chao <chaowang@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, kexec@lists.infradead.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "H. Peter Anvin" <hpa@zytor.com>, mjg59@srcf.ucam.org,
        Greg Kroah-Hartman <greg@kroah.com>, Borislav Petkov <bp@alien8.de>,
        Jiri Kosina <jkosina@suse.cz>, dyoung@redhat.com, bhe@redhat.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux API <linux-api@vger.kernel.org>
Subject: Re: [RFC PATCH 00/13][V3] kexec: A new system call to allow in kernel
 loading
References: <1401800822-27425-1-git-send-email-vgoyal@redhat.com> <20140603131203.GA23395@redhat.com> <20140604092214.GA17528@dhcp-17-89.nay.redhat.com> <20140604175031.GA4406@redhat.com> <CAHO5Pa0dxpq7YNe5eUMPE9Mn5m7XCnB1C5mZxrvt2-OqOpVZAA@mail.gmail.com> <20140605140416.GB17389@redhat.com>
In-Reply-To: <20140605140416.GB17389@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2014 04:04 PM, Vivek Goyal wrote:
> On Wed, Jun 04, 2014 at 09:39:10PM +0200, Michael Kerrisk wrote:
>> Vivek,
>>
>> As per Documentation/SubmitChecklist , please CC linux-api@ on patces
>> that change the ABI/API. See
>> https://www.kernel.org/doc/man-pages/linux-api-ml.html.
> 
> Hi Michael,
> 
> Sorry, I did not notice that. I will CC linux-api@ in next version of
> patches in patches which introduce new systemcal..
> 
>>
>> Also, is there some draft man page for this new system call?
> 
> No, there is none yet. In fact I don't see a man page for old kexec
> system call either kexec_load().

Is this not what you are meaning:
http://man7.org/linux/man-pages/man2/kexec_load.2.html
?
(It probably could be improved...)

> Do you want me to write man page for this new syscall?

These days, that's considered a desirable accompaniment to new 
syscall proposals.

Cheers,

Michael



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
