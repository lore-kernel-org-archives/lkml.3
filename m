Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752487AbaEUOFS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 10:05:18 -0400
Received: from mail-ve0-f174.google.com ([209.85.128.174]:40208 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336AbaEUOFQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 10:05:16 -0400
MIME-Version: 1.0
In-Reply-To: <2643156.2tkLFqgYFg@sigyn>
References: <1398524543-15012-1-git-send-email-madcatxster@devoid-pointer.net>
	<1c6140633925b0838b7627e071e80761.squirrel@mungewell.org>
	<537BFEBF.8010601@logitech.com>
	<2643156.2tkLFqgYFg@sigyn>
Date: Wed, 21 May 2014 16:05:14 +0200
Message-ID: <CADbOyBROC4eeUWkEG687bwOXyqDieD+wt7J855H0z6F=Mchx_w@mail.gmail.com>
Subject: Re: [PATCH v4 01/24] input: Add ff-memless-next module
From: Elias Vanderstuyft <elias.vds@gmail.com>
To: Simon Wood <simon@mungewell.org>
Cc: Roland Bosa <rbosa@logitech.com>,
        =?UTF-8?B?TWljaGFsIE1hbMO9?= <madcatxster@devoid-pointer.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>, Anssi Hannula <anssi.hannula@iki.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2014 at 4:13 AM, Michal Malý
<madcatxster@devoid-pointer.net> wrote:
> On Tuesday 20 of May 2014 18:17:51 Roland Bosa wrote:
>>
>> The file format of an IFR is probably easily deducible. There's a lot of
>> textual clues to parameters and the values are also written out in
>> string form.
>>
>> I don't have a FEdit file at hand, but I suppose it will be similar.
>
> I believe that Elias successfully reverse engineered the effect file format
> produced by FEdit. There is no support for this kind of prefabricated effects
> in the Linux FF API.

Of course I did, Simon, what did you expect? :P
Here you are:
http://www.winehq.org/pipermail/wine-devel/2014-February/103108.html
It contains a description of the DInput effect file format (.ffe), a
working Python script to load these files and dump their contents, as
well as a bunch of example files and tests/results.
The FFE file format is binary RIFF, if you're interested.

But I prefer not to include such things in the Linux kernel, I believe
this is the task of the userspace application.
I'm planning to implement this function into Wine, but maybe SDL would
benefit from similar functionality too (using an open file-format
instead, of course)?
Anyway, this is off-topic.

Elias
