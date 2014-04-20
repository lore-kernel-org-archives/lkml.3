Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152AbaDTRoX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2014 13:44:23 -0400
Received: from mail.csclub.uwaterloo.ca ([129.97.134.52]:35989 "EHLO
	mail.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbaDTRoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2014 13:44:21 -0400
From: "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>
Date: Sun, 20 Apr 2014 13:44:18 -0400
To: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Jos Huisken <jos.huisken@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: inotify, new idea?
Message-ID: <20140420174418.GN17765@csclub.uwaterloo.ca>
References: <CAOiKX_m8buaq=4_hVQjyfv36ZtFVFieZ-CU8JeDpcdbeiX5mug@mail.gmail.com>
 <20140417212834.GC17769@csclub.uwaterloo.ca>
 <CAHO5Pa1Rb5YkXF_0iE_KUhOOGeNo+zV+OWQW6L8_ix=iFvkTyg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHO5Pa1Rb5YkXF_0iE_KUhOOGeNo+zV+OWQW6L8_ix=iFvkTyg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2014 at 06:15:40AM +0200, Michael Kerrisk wrote:
> (One of us is misunderstanding fanotify; it might be me.)

No I think you are right, and that the misunderstanding is on my part.
I had not realized that fanotify did not provide create/delete events,
only access events.

> Did you look at fanotify closely? I don't think it could be used for
> this task -- does not notify linka dn unlink events, difficult to set
> up recursive monitoring, etc.

It would appear you are correct.

-- 
Len Sorensen
