Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751565Ab3CKNS5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 09:18:57 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:51823 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872Ab3CKNSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 09:18:55 -0400
MIME-Version: 1.0
In-Reply-To: <20130303224150.GA22048@kroah.com>
References: <20130116141627.GA23638@ioremap.net>
	<20130302001103.GB18026@gmail.com>
	<20130302094510.GA4695@geggus.net>
	<20130302135015.GA21448@gmail.com>
	<20130303205452.GA2064@ioremap.net>
	<20130303224150.GA22048@kroah.com>
Date: Mon, 11 Mar 2013 09:18:55 -0400
Message-ID: <CA+5PVA7C2c1yUDSrq-bkC-GH2bwUYWc_0BXAydAEoQn0tpO9XA@mail.gmail.com>
Subject: Re: [PATCH 1/1] w1: fix oops when w1_search is called from netlink connector
From: Josh Boyer <jwboyer@gmail.com>
To: GregKH <greg@kroah.com>
Cc: Evgeniy Polyakov <zbr@ioremap.net>, Marcin Jurkowski <marcin1j@gmail.com>,
        Sven Geggus <lists@fuchsschwanzdomain.de>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 3, 2013 at 5:41 PM, GregKH <greg@kroah.com> wrote:
> On Mon, Mar 04, 2013 at 12:54:52AM +0400, Evgeniy Polyakov wrote:
>> Hi
>>
>> Marcin, thanks a lot for the fix, I have to sorry I'm not on this bug yet :(
>> Sven confirmed patch fixes it, Greg please pull it into your tree.
>
> Ok, will do once 3.9-rc1 is out.

3.9-rc2 is out now.  I don't see this in any of your trees.  Just a reminder.

josh
