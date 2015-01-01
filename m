Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751654AbbAAKMN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 05:12:13 -0500
Received: from mail-oi0-f45.google.com ([209.85.218.45]:62622 "EHLO
	mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbbAAKMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 05:12:10 -0500
MIME-Version: 1.0
In-Reply-To: <20150101045848.GC3645@sudip-PC>
References: <1420060243-10685-1-git-send-email-lstoakes@gmail.com>
	<1420060243-10685-3-git-send-email-lstoakes@gmail.com>
	<20150101044956.GB3645@sudip-PC>
	<20150101045848.GC3645@sudip-PC>
Date: Thu, 1 Jan 2015 10:12:09 +0000
Message-ID: <CAA5enKYLZuZxuRPQec8r-4rohb-nJKWM=4sTagP3PgkXfVMp=g@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] staging: rtl8192u: remove redundant code
From: Lorenzo Stoakes <lstoakes@gmail.com>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: gregkh@linuxfoundation.org, Ana Rey <anarey@gmail.com>,
        mcgrof@do-not-panic.com, tapaswenipathak@gmail.com,
        Joe Perches <joe@perches.com>, Rui Silva <rmfrfs@gmail.com>,
        Jiayi Ye <yejiayily@gmail.com>, Greg Donald <gdonald@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1 January 2015 at 04:58, Sudip Mukherjee <sudipm.mukherjee@gmail.com> wrote:
> On Thu, Jan 01, 2015 at 10:19:56AM +0530, Sudip Mukherjee wrote:
>> but this is just removal of unnecessary braces. this is not removal of redundant code.

Hi Sudip,

Again in the same theme as the whitespace changes I felt I could
fairly reasonably package up a set of similar changes which remove
redundant *symbols* of one kind or another, which though they might
not constitute significant reduction in redundant code could
reasonably come under that header.

Again I'm more than happy to edit the message to describe this change
more correctly and/or split further though, as before, I'm wary of
splitting too much as to cause irritation to reviewers.

> and, missed writing in the last mail.
> your [PATCH v2 2/4] and [PATCH v2 3/4] are same.

Apologies for this, I simply batched up the whole set once again
without checking what would remain the same or not. I don't make this
mistake for the v3 of patch 2 and will be careful to avoid this in
future!

Best, Lorenzo
