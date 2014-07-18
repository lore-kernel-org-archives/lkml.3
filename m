Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030597AbaGRRUn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 13:20:43 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:57942 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030449AbaGRRUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 13:20:41 -0400
MIME-Version: 1.0
In-Reply-To: <20140718074143.GB20028@ravnborg.org>
References: <CAPDOMViDWF93xDQ=OYWFEu=9ih6cwcEKv4P+nOihcnRrDXiAww@mail.gmail.com>
	<20140718074143.GB20028@ravnborg.org>
Date: Fri, 18 Jul 2014 13:20:40 -0400
Message-ID: <CAPDOMVhq969+pCRZckat9RW3m44RMG0mHzyUuPJzvGBHhW-1Qw@mail.gmail.com>
Subject: Re: Sparc Allmodconfig Fails
From: Nick Krause <xerofoify@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: David Miller <davem@davemloft.net>, sparclinux@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 3:41 AM, Sam Ravnborg <sam@ravnborg.org> wrote:
> On Fri, Jul 18, 2014 at 12:21:04AM -0400, Nick Krause wrote:
>> The build for sparc allmodconfig is still failing for the main branch
>> of the linux kernel.
>> I would recommend fixing these issues. I am attaching my build
>> warnings and errors
>> logs for the failing build test I did today.
>
> Did you actually look into the log yourself?
>
> This should give you a hint:
>
> make[1]: *** No rule to make target `/media/nick/Nick's', needed by
> +`kernel/x509_certificate_list'.  Stop.
>
>
> All the rest are random warnings that may or may not be specific for sparc64.
>
>         Sam

I did , needs this issue is on my computer. I thought that this was a common
error. Therefore it seems it builds correctly now if we exclude my build error.
Cheers Nick
