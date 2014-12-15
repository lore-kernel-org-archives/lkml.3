Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751129AbaLOVVP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 16:21:15 -0500
Received: from mail-oi0-f51.google.com ([209.85.218.51]:33666 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723AbaLOVVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 16:21:13 -0500
MIME-Version: 1.0
In-Reply-To: <CA+5PVA49YBQMz1fardM8wP6R1n_QGCXudeu_KaSsYwaiHmMzWg@mail.gmail.com>
References: <20141214201823.543296369@linuxfoundation.org>
	<20141214201823.978185416@linuxfoundation.org>
	<20141215154650.GA6542@vader>
	<20141215163419.GA1351@kroah.com>
	<CA+5PVA49YBQMz1fardM8wP6R1n_QGCXudeu_KaSsYwaiHmMzWg@mail.gmail.com>
Date: Mon, 15 Dec 2014 16:21:12 -0500
X-Google-Sender-Auth: Jt11RmQEZdHQxyIvkxIsqZLKpac
Message-ID: <CA+5PVA6jZgOeDko_b5y2i8rYaxq_QWSfeDJ4RtA-1uZW87G+4Q@mail.gmail.com>
Subject: Re: [PATCH 3.18 15/19] move d_rcu from overlapping d_child to
 overlapping d_alias
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2014 at 11:38 AM, Josh Boyer <jwboyer@fedoraproject.org> wrote:
> On Mon, Dec 15, 2014 at 11:34 AM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
>> On Mon, Dec 15, 2014 at 10:46:50AM -0500, Josh Boyer wrote:
>>> On Sun, Dec 14, 2014 at 12:21:26PM -0800, Greg Kroah-Hartman wrote:
>>> >3.18-stable review patch.  If anyone has any objections, please let me know.
>>> >
>>> >------------------
>>> >
>>> >From: Al Viro <viro@zeniv.linux.org.uk>
>>> >
>>> >commit 946e51f2bf37f1656916eb75bd0742ba33983c28 upstream.
>>> >
>>> >Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
>>> >Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>>
>>> I noticed you don't have this (and the child commit) queued for 3.17.y.
>>
>> That is because:
>>
>>> The backport wasn't exactly straight-forward because of the d_external
>>> stuff, but I took a swing at it.  After that, the other commit was a
>>> quick cherry-pick.
>>
>> It wasn't a "simple" backport, and I didn't have the time.  I'm also
>> going to drop 3.17 real-soon-now.
>
> Right, figured.  Fedora isn't going to rebase the stable releases to
> 3.18 until 3.18.2-ish, and this fixes an issue so I thought I'd give
> it a try.
>
>>> Al, does the below look correct for a backport on top of 3.17.6?  It
>>> builds, but I haven't tested it yet.
>>
>> Testing would be great to do :)
>
> Working on it.  Just wanted to send it out early in case Al spotted
> something obviously wrong and wanted to yell at me for it.

Finally got around to booting it.  Something is definitely wrong.  Sigh.

josh
