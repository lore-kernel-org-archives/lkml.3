Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753711Ab3AQWcO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 17:32:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32525 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752965Ab3AQWcM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 17:32:12 -0500
Message-ID: <50F87BCA.10201@redhat.com>
Date: Thu, 17 Jan 2013 14:31:38 -0800
From: Andy Grover <agrover@redhat.com>
Organization: Red Hat
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.11) Gecko/20121116 Thunderbird/10.0.11
MIME-Version: 1.0
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
CC: Andreas Steinmetz <ast@domdv.de>, linux-kernel@vger.kernel.org,
        hch@infradead.org, torvalds@linux-foundation.org,
        target-devel <target-devel@vger.kernel.org>,
        Ritesh Raj Sarraf <rrs@debian.org>
Subject: Re: LIO - the broken iSCSI target implementation
References: <1358385543.7040.54.camel@host028-server-9.lan.domdv.de> <1358456179.18551.34.camel@haakon2.linux-iscsi.org>
In-Reply-To: <1358456179.18551.34.camel@haakon2.linux-iscsi.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2013 12:56 PM, Nicholas A. Bellinger wrote:
> On Thu, 2013-01-17 at 02:19 +0100, Andreas Steinmetz wrote:
>> This is not a technical point of view. This is a more or less political
>> and user point of view. And for any replies, I'm not subscribed (haven't
>> been now for years).
>>
>> As a user, I was in need for an iSCSI target. Actually, I needed to
>> export a SAS tape device (Ultrium 5) - which is one of the devices still
>> sufficiently expensive to go the iSCSI target way) - well, not any disks
>> (cheap enough, NFS available) or CD/DVD writers (I'd call these penny
>> targets nowadays).
>>
>> Thus, lio (http://www.linux-iscsi.org/) seemed to be the politically and
>> technically favoured solution. Except: it simply doesn't work, userspace
>> utilities are seemingly not maintained,
> 
> I'm not sure what you mean.  There are targetcli+rtslib packages are
> available for virtually every distribution
> 
> http://www.linux-iscsi.org/wiki/Targetcli#Linux_distributions

[CCing rrs@debian.org]

No... actually upstream targetcli/rtslib are not very well maintained.
Around 5 patches each in the last year.

Meanwhile, I have been actively maintaining branches at
github.com/agrover/targetcli-fb and github.com/agrover/rtslib-fb. We
have a man page and screencasts even. Feel free to file bugs against
them and I'll respond.

But I'm only packaging for Fedora/RHEL, so random people on Debian etc.
get a bad experience. I'd like to see upstream accept my AGPLv3-licensed
patches, or have Debian package the -fb versions, either instead or in
addition to the upstream versions.

(I'd kinda been waiting to bring it up until upstream had no commits in
a year, but since you mentioned it...)

Regards -- Andy
