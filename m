Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756456Ab3FEOtu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 10:49:50 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:55246 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756392Ab3FEOts convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 10:49:48 -0400
MIME-Version: 1.0
In-Reply-To: <1370316933.30695.7.camel@linux-s257.site>
References: <1370117180-1712-1-git-send-email-matthew.garrett@nebula.com>
	<1370276021.30695.4.camel@linux-s257.site>
	<1370277079.6315.14.camel@x230.lan>
	<1370316933.30695.7.camel@linux-s257.site>
Date: Wed, 5 Jun 2013 15:49:45 +0100
Message-ID: <CAL01qptzxe5L6Vq+nBZLq+bQNxbe_i_2OdKMNJGZQDfMihaHOw@mail.gmail.com>
Subject: Re: [PATCH] Modify UEFI anti-bricking code
From: "Fleming, Matt" <matt.fleming@intel.com>
To: joeyli <jlee@suse.com>
Cc: Matthew Garrett <matthew.garrett@nebula.com>, "rja@sgi.com" <rja@sgi.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "bp@alien8.de" <bp@alien8.de>, "jkosina@suse.cz" <jkosina@suse.cz>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "oneukum@suse.de" <oneukum@suse.de>
Content-Type: text/plain; charset=Big5
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 June 2013 04:35, joeyli <jlee@suse.com> wrote:
> 於 一，2013-06-03 於 16:31 +0000，Matthew Garrett 提到：
>> On Tue, 2013-06-04 at 00:13 +0800, joeyli wrote:
>>
>> > Oliver raised a question for if power fails between that succesful
>> > attempt and the deletion?
>>
>> It's a pretty tiny window, but sure. Making sure we delete it seems
>> sensible. In that case we should make the GUID a #define rather than
>> write it out twice.
>>
>
> Base on your patch, the following diff moved DUMMY GUID to #define, and
> add a static efi name string:

Folks, what do you want me to do with this? Merge it with Matthew's patch?

The feedback from the original patch has been pretty good so I'm happy
to pick it up and get it sent to Linus.
