Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757218Ab3JJTGp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 15:06:45 -0400
Received: from mail-qa0-f47.google.com ([209.85.216.47]:61068 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756150Ab3JJTGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 15:06:43 -0400
MIME-Version: 1.0
In-Reply-To: <0683F5F5A5C7FE419A752A034B4A0B97973FD07B@sswchi5pmbx2.peak6.net>
References: <CAG-aW07mUqX5t-g4_cCvSVxrArzmc-vsOaPoHcFJuo_fXeRnzw@mail.gmail.com>
	<CAG-aW07kVTurn2mTH_2qR31wdOEzxfP34-6eR34MvNZaMkGYkw@mail.gmail.com>
	<0683F5F5A5C7FE419A752A034B4A0B97973FD07B@sswchi5pmbx2.peak6.net>
Date: Thu, 10 Oct 2013 21:06:42 +0200
Message-ID: <CAG-aW07vf2nBeHGna+92qn02uAfVdGrdjx-a0E0Ez7Xx4C-rEg@mail.gmail.com>
Subject: Re: Very odd memory behavior. Is this normal?
From: Matt <jackdachef@gmail.com>
To: Shaun Thomas <sthomas@optionshouse.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 10, 2013 at 8:57 PM, Shaun Thomas <sthomas@optionshouse.com> wrote:
>> just a user here, with a little android-kernel related experience who
>> also likes to tinker with the desktop kernel :)
>>
>> Have you given the following patchset a try yet:
>>
>> http://linux-kernel.2935.n7.nabble.com/patch-v2-0-3-mm-improve-
>> page-aging-fairness-between-zones-nodes-td696105.html
>
> Holy cow, that looks extremely promising. What version of the kernel is this compatible with? It looks like 3.11, but I'm not sure.
>
> Thanks!
>
> --
> Shaun Thomas
> OptionsHouse | 141 W. Jackson Blvd | Suite 500 | Chicago IL, 60604
> 312-676-8870
> sthomas@optionshouse.com
>
>

CC'ing: Johannes Weiner


I started using it with a 3.10 kernel (V1, V2) and now have it applied
against a heavily modified 3.11 kernel (V2).

So I can't say anything whether it'll work with older versions of the
kernel but the following:

it's "stable" material which needs backporting to the longterm kernels ;)


Glad if I can be of help


Matt
