Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750959AbaHQERA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 00:17:00 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:41453 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728AbaHQEQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 00:16:58 -0400
MIME-Version: 1.0
In-Reply-To: <20140816081007.GA21682@Nokia-N900>
References: <1817539.9KW2IGGbDV@vostro.rjw.lan>
	<2242480.eT2OxdNqLH@vostro.rjw.lan>
	<20140730105529.GB12448@amd.pavel.ucw.cz>
	<3319219.i7p5TE6seQ@vostro.rjw.lan>
	<20140816081007.GA21682@Nokia-N900>
Date: Sun, 17 Aug 2014 06:16:57 +0200
X-Google-Sender-Auth: Jw-jn-LdgPiHSvudnV9SgHsZxQo
Message-ID: <CAJZ5v0gQsjjfPwksuhmeL062es7ge-4CPAJkOP1ft5Ka0L4w=Q@mail.gmail.com>
Subject: Re: [PATCH 3/3][update] PM / sleep: Introduce command line argument
 for sleep state enumeration
From: "Rafael J. Wysocki" <rafael@kernel.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 16, 2014 at 10:10 AM, Pavel Machek <pavel@ucw.cz> wrote:
> On Fri 2014-08-01 15:54:32, Rafael J. Wysocki wrote:
>> On Wednesday, July 30, 2014 12:55:29 PM Pavel Machek wrote:
>> >
>> > > For this reason I'm considering changing the defaul behavior going forward (so
>> > > that "mem" is always present and means "the deepest sleep state available other
>> > > than hibernation"), but I don't want to do that in one go.
>> >
>> > Actually, I don't think that's good idea, at least on PC.
>> >
>> > The way to wake up from S3 is power button. The way to wake up from
>> > "echo freeze > state" is going to be different, right?
>>
>> No, it isn't.  That's the point among other things.
>
> There's difference, actually.
>
> From S3, power button event is consumed.
>
> From freeze, after resume, "what you want to do? power off,
> suspend, hibernate" dialog appears.

In 3.17-rc1 it shouldn't.  Have you tested this one?

Rafael
