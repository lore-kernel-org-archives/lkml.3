Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934605Ab3DHBO3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 21:14:29 -0400
Received: from mail-gh0-f180.google.com ([209.85.160.180]:45802 "EHLO
	mail-gh0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934526Ab3DHBO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 21:14:27 -0400
Message-ID: <51621AC2.4070706@gmail.com>
Date: Sun, 07 Apr 2013 22:17:54 -0300
From: Lucas <canolucas@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130403 Thunderbird/17.0.5
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.stable,gmane.linux.kernel
To: Daniel Vetter <daniel.vetter@ffwll.ch>
CC: Greg KH <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        stable <stable@vger.kernel.org>,
        "Kuoppala, Mika" <mika.kuoppala@intel.com>,
        Andreas Sturmlechner <andreas.sturmlechner@gmail.com>
Subject: Re: Linux 3.8.6
References: <20130405174012.GA28836@kroah.com> <51606512.8030703@gmail.com> <20130406181836.GA2406@kroah.com> <51606D06.5020606@gmail.com> <CAKMK7uEF6sfvMvut7JVCjsKbgzarr8acqELnC0iLrHyKo=b+tQ@mail.gmail.com> <5160A81E.2010505@gmail.com> <CAKMK7uGjzYF0XG78US7OyoK2xnvn4jw25f26d28QS=CR_Ta=nQ@mail.gmail.com>
In-Reply-To: <CAKMK7uGjzYF0XG78US7OyoK2xnvn4jw25f26d28QS=CR_Ta=nQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/04/13 15:28, Daniel Vetter wrote:
> On Sun, Apr 7, 2013 at 12:56 AM, Lucas <canolucas@gmail.com> wrote:
>> Thanks for reporting in.
>>
>> Somehow the thread got all messed up in LKML. It didn't parse correctly
>> there, but it seems that Gmane did. Here is the link:
>>
>> http://comments.gmane.org/gmane.linux.kernel.stable/48872
>
> Those patches still have an unresolved regression against them.
> Unfortunately  I can't reproduce it despite that I have a very similar
> system, and obviously a bunch of other people like you reported that
> the exact same patches which regressed actually fix the lvds panel
> fitter. So for now this stays in limbo :(
> -Daniel
> --
> Daniel Vetter
> Software Engineer, Intel Corporation
> +41 (0) 79 365 57 48 - http://blog.ffwll.ch
>
Ok, if you need any help with testing or anything, just tell me.
For me every release candidate of 3.9 from rc1 onwards is able to boot 
X. Hope you can hunt this regresion down.

Thanks,
Lucas
