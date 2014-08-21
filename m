Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716AbaHUHZA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 03:25:00 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006AbaHUHZA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 03:25:00 -0400
Message-ID: <53F59EC7.6060107@nod.at>
Date: Thu, 21 Aug 2014 09:24:55 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "libvir-list@redhat.com" <libvir-list@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>
Subject: Re: [GIT PULL] namespace updates for v3.17-rc1
References: <87fvhav3ic.fsf@x220.int.ebiederm.org>	<CAFLxGvwi-iJRyfwv8v9fcRkiSu2d-az8W55xMPbp_d8wQKmwjg@mail.gmail.com> <87vbpm4f4y.fsf@x220.int.ebiederm.org> <53F591E7.3010509@nod.at>
In-Reply-To: <53F591E7.3010509@nod.at>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 21.08.2014 08:29, schrieb Richard Weinberger:
> Am 21.08.2014 06:53, schrieb Eric W. Biederman:
>> The bugs fixed are security issues, so if we have to break a small
>> number of userspace applications we will.  Anything that we can
>> reasonably do to avoid regressions will be done.
>>
>> Could you please look at my user-namespace.git#for-next branch I have a
>> fix for at least one regresion causing issue in there.  I think it may
>> fix your issues but I am not fully certain more comments below.
> 
> I'll run this on my LXC testbed today.

Looks good. With these patches applied libvirt works again. :)

Thanks,
//richard
