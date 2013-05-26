Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369Ab3EZWOK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 18:14:10 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:49520 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755257Ab3EZWOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 18:14:08 -0400
MIME-Version: 1.0
In-Reply-To: <20130425101932.GA5909@gmail.com>
References: <1354210800-27230-1-git-send-email-dinggnu@gmail.com>
	<20121211012112.GA11273@local>
	<CAM3j68oNeb5HVYVHTSnQoiBHa7T4krkiDLy0dQkBZUd5BQgo2w@mail.gmail.com>
	<20130118220050.GA31286@kroah.com>
	<20130120210140.GA13035@local>
	<20130214114315.GB18774@gmail.com>
	<20130425101932.GA5909@gmail.com>
Date: Mon, 27 May 2013 00:14:08 +0200
X-Google-Sender-Auth: sQqAGJepUq1xirxTJSvUszprCNk
Message-ID: <CAM3j68pGMwC9zeUDktav_9ZmHM__n_prM_d+-m-MXZCPETOFQg@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] uio.c: solve memory leak
From: Cong Ding <dinggnu@gmail.com>
To: "Hans J. Koch" <hjk@hansjkoch.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 25, 2013 at 12:19 PM, Cong Ding <dinggnu@gmail.com> wrote:
> On Thu, Feb 14, 2013 at 12:43:15PM +0100, Cong Ding wrote:
>> On Sun, Jan 20, 2013 at 10:01:41PM +0100, Hans J. Koch wrote:
>> > On Fri, Jan 18, 2013 at 02:00:50PM -0800, Greg Kroah-Hartman wrote:
>> > > On Fri, Jan 18, 2013 at 10:05:45PM +0100, Cong Ding wrote:
>> > > > On Tue, Dec 11, 2012 at 2:21 AM, Hans J. Koch <hjk@hansjkoch.de> wrote:
>> > > > > On Thu, Nov 29, 2012 at 05:40:00PM +0000, Cong Ding wrote:
>> > > > >> In version 1, I forgot to modify the same bug in the first loop.
>> > > > >>
>> > > > >> we have to call kobject_put() to clean up the kobject after function
>> > > > >> kobject_init(), kobject_add(), or kobject_uevent() is called.
>> > > > >>
>> > > > >> Signed-off-by: Cong Ding <dinggnu@gmail.com>
>> > > > >
>> > > > > Signed-off-by: "Hans J. Koch" <hjk@hansjkoch.de>
>> > > >
>> > > > Hi Greg, is this patch stil in the queue?
>> > >
>> > > Hans is queueing up UIO patches to send to me, I'm waiting for him to
>> > > send them as I don't have any in my trees.
>> >
>> > I'll set that up tonight or tomorrow. Sorry, I was delayed by illness
>> > and a lot of other work.
>> Hi Hans, what's this going on?
>>
>> Thanks, - cong
Hi Hans, it's another month. What's the progress of this patch?
 - cong
