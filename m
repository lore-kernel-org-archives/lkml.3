Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456Ab3BKITO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 03:19:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3573 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752968Ab3BKITN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 03:19:13 -0500
Message-ID: <5118A979.4090807@redhat.com>
Date: Mon, 11 Feb 2013 09:19:05 +0100
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Joe Perches <joe@perches.com>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib: memcmp_nta: add timing-attack secure memcmp
References: <cover.1360528614.git.dborkman@redhat.com> <e73de7873eadcd7a1922535359c46caf25cbf0a2.1360528614.git.dborkman@redhat.com> <1360538650.2028.2.camel@joe-AO722> <51182DAB.1030708@redhat.com> <20130210235057.GA5485@kroah.com>
In-Reply-To: <20130210235057.GA5485@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/2013 12:50 AM, Greg KH wrote:
> On Mon, Feb 11, 2013 at 12:30:51AM +0100, Daniel Borkmann wrote:
>> On 02/11/2013 12:24 AM, Joe Perches wrote:
>>> On Sun, 2013-02-10 at 23:00 +0100, Daniel Borkmann wrote:
>>>> add memcmp_nta ({n}o {t}iming {a}ttacks)
>>>
>>> Why should this be in the kernel?
>>
>> As the commit message already says, so that current or future (e.g.) network
>> protocol code or modules can make use of this when dealing with cryptographic
>> hash comparisons.
>
> Do we have any in-kernel users that need this?  If not, then don't add
> it now, but rather, add it when we actually have a user.  We almost
> never add kernel functions that no one calls, that would be just
> wasteful.

Agreed, I think there are users for it. But I'll resend a set at a later point
in time, after some more testing and verifying.

Thanks, Greg.
