Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966308Ab3DQMON (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 08:14:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17255 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966134Ab3DQMOM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 08:14:12 -0400
Message-ID: <516E9205.3070200@redhat.com>
Date: Wed, 17 Apr 2013 20:13:57 +0800
From: Lingzhu Xiang <lxiang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Andy Whitcroft <apw@canonical.com>
CC: Luis Henriques <luis.henriques@canonical.com>,
        Matt Fleming <matt.fleming@intel.com>, Josh Boyer <jwboyer@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, "Lee, Chun-Yi" <jlee@suse.com>,
        "kernel-team@lists.ubuntu.com" <kernel-team@lists.ubuntu.com>,
        Seiji Aguchi <seiji.aguchi@hds.com>, Michael Schroeder <mls@suse.com>
Subject: Re: [PATCH 097/102] efivars: explicitly calculate length of VariableName
References: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com> <1365414657-29191-98-git-send-email-luis.henriques@canonical.com> <1365547506.5814.36.camel@deadeye.wl.decadent.org.uk> <51653E81.4090102@redhat.com> <20130410121730.GB3049@hercules> <A5ED84D3BB3A384992CBB9C77DEDA4D41AF8D09E@USINDEM103.corp.hds.com> <20130411091256.GA11370@hercules> <20130416103321.GB3054@hercules> <516E2717.3020309@redhat.com> <20130417115641.GG15755@dm>
In-Reply-To: <20130417115641.GG15755@dm>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/2013 07:56 PM, Andy Whitcroft wrote:
> On Wed, Apr 17, 2013 at 12:37:43PM +0800, Lingzhu Xiang wrote:
>> On 04/16/2013 06:33 PM, Luis Henriques wrote:
>>> 68d929862e29a8b52a7f2f2f86a0600423b093cd efi: be more paranoid about available space when creating variables
>>
>> This prevents a bricking issue for some Samsung devices but causes
>> regression on many other machines.
>>
>> https://bugzilla.kernel.org/show_bug.cgi?id=55471
>> https://bugzilla.redhat.com/show_bug.cgi?id=947142
>> http://article.gmane.org/gmane.linux.kernel.efi/1078
>> http://article.gmane.org/gmane.linux.kernel.stable/47150
>>
>> This patchset will fix it again:
>>
>> http://thread.gmane.org/gmane.linux.kernel.efi/1081
>
> Thanks for the pointer.  I note that in that thread you yourself imply
> there are still issues after applying them?  Was that accurate, is there
> yet further patches needed?

I just find that issue. Didn't see that when writing the above.

Earlier I was testing on a different machine and the result was good. I 
guess the patch still needs some more testing.


Lingzhu
