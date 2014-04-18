Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751195AbaDREQF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 00:16:05 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:52198 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbaDREQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 00:16:02 -0400
MIME-Version: 1.0
In-Reply-To: <20140417212834.GC17769@csclub.uwaterloo.ca>
References: <CAOiKX_m8buaq=4_hVQjyfv36ZtFVFieZ-CU8JeDpcdbeiX5mug@mail.gmail.com>
 <20140417212834.GC17769@csclub.uwaterloo.ca>
From: Michael Kerrisk <mtk.manpages@gmail.com>
Date: Fri, 18 Apr 2014 06:15:40 +0200
X-Google-Sender-Auth: _PiCd56PMc3TpJ-g40jYD-RR--0
Message-ID: <CAHO5Pa1Rb5YkXF_0iE_KUhOOGeNo+zV+OWQW6L8_ix=iFvkTyg@mail.gmail.com>
Subject: Re: inotify, new idea?
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: Jos Huisken <jos.huisken@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 11:28 PM, Lennart Sorensen
<lsorense@csclub.uwaterloo.ca> wrote:
> On Thu, Apr 17, 2014 at 11:00:37PM +0200, Jos Huisken wrote:
>> I was trying to maintain a local and remote directory in sync with
>> lsync, using inotify.
>> I happen to have >4M files and >400k directories... running over
>> /proc/sys/fs/inotify/max_user_watches
>
> Would fanotify perhaps be a better interface to use?

(One of us is misunderstanding fanotify; it might be me.)

Did you look at fanotify closely? I don't think it could be used for
this task -- does not notify linka dn unlink events, difficult to set
up recursive monitoring, etc.

Cheers,

Michael
