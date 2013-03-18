Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933494Ab3CRVfe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 17:35:34 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:36934 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932374Ab3CRVf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 17:35:29 -0400
MIME-Version: 1.0
In-Reply-To: <20130318212046.GA13813@kroah.com>
References: <20130318210510.203500214@linuxfoundation.org>
	<20130318210512.334023372@linuxfoundation.org>
	<CABPqkBQquwGc6S3Jfz1tgm2SZhA3pFuSC8xvAojLFk-6G3gqAA@mail.gmail.com>
	<20130318212046.GA13813@kroah.com>
Date: Mon, 18 Mar 2013 22:35:27 +0100
Message-ID: <CABPqkBQQvykujp6rV2PipRKNRP2s+DLT7J-YUWJVabQsCi34rQ@mail.gmail.com>
Subject: Re: [ 29/75] perf,x86: fix kernel crash with PEBS/BTS after suspend/resume
From: Stephane Eranian <eranian@google.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 18, 2013 at 10:20 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Mon, Mar 18, 2013 at 10:11:28PM +0100, Stephane Eranian wrote:
>> On Mon, Mar 18, 2013 at 10:06 PM, Greg Kroah-Hartman
>> <gregkh@linuxfoundation.org> wrote:
>> > 3.8-stable review patch.  If anyone has any objections, please let me know.
>> >
>> Greg, you also need to pick David Rientjes patch to fix compilation on
>> non X86 architectures.
>
> What git commit id would that be?  I thought I picked up everything that
> was needed after this one went in, what did I miss?
>
Talking about this particular patch: https://lkml.org/lkml/2013/3/17/183
Don't know if it's in already.
