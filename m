Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875AbaJMM0i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 08:26:38 -0400
Received: from mail-oi0-f51.google.com ([209.85.218.51]:38700 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753741AbaJMM0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 08:26:36 -0400
Date: Mon, 13 Oct 2014 07:26:32 -0500
From: Chuck Ebbert <cebbert.lkml@gmail.com>
To: Udo van den Heuvel <udovdh@xs4all.nl>
Cc: Peter Hurley <peter@hurleysoftware.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: CRASH during boot 3.16.3+
Message-ID: <20141013072632.07b8fa64@as>
In-Reply-To: <543BA610.8010001@xs4all.nl>
References: <543A88E4.4060707@xs4all.nl>
	<543ABD7D.5010308@hurleysoftware.com>
	<543BA610.8010001@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Oct 2014 12:14:40 +0200
Udo van den Heuvel <udovdh@xs4all.nl> wrote:

> On 2014-10-12 19:42, Peter Hurley wrote:
> > On 10/12/2014 09:57 AM, Udo van den Heuvel wrote:
> >> The problem:
> >> During the first few seconds of bootup the kernel gets into some sort of
> >> loop and rapidly prints loads of register-like things and then a load of
> >> rubbish.
> >> I did `make clean` and then a rebuild etc but this did not help.
> >>
> >> How can I capture the logging to find the point where things go wrong?
> >> How can I find out what is wrong?
> > 
> > Start with git bisect between good=3.16.2 and bad=3.16.3.
> > And dmesg from 3.16.2.
> 
> Incomplete dmesg attached for 3.16.2.
> 
> > What happens after the 'then a load of rubbish.'?
> 
> I press reset as this is unexpected and looks like it will not result in
> a succesfull boot.
> 
> > And rubbish is not
> very descriptive. Please include a sample, if you can't catch all the
> console prints.
> 
> How can I capture the output easily?

Add "boot_delay=3000" to the kernel command line. This will add a 3
second delay between each line. Then take pictures of the screen
while it boots. And try to time the shots so you take them during the
delays.
