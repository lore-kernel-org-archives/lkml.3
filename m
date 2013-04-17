Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757054Ab3DQQZp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 12:25:45 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:44116 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754277Ab3DQQZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 12:25:42 -0400
MIME-Version: 1.0
In-Reply-To: <20130408183012.GA5778@linutronix.de>
References: <20130326201722.GA14220@linutronix.de>
	<CAP=VYLoXfECaSBuvYdZ3qbsnR9QMYpoRnKGZdY=P6zS_TYOcCA@mail.gmail.com>
	<20130408183012.GA5778@linutronix.de>
Date: Wed, 17 Apr 2013 18:25:40 +0200
X-Google-Sender-Auth: j6WkrLy-dTaPrwg7jkmz_HGZ_g0
Message-ID: <CAONaPpFSf+Eh3K3BHCsPTQdxmbghHhtH=wMooh+Ers2QiCdH=g@mail.gmail.com>
Subject: Re: [ANNOUNCE] 3.8.4-rt2
From: John Kacur <jkacur@redhat.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 8, 2013 at 8:30 PM, Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:
> * Paul Gortmaker | 2013-04-05 19:35:51 [-0400]:
>
>>Thanks for the work in putting this together.  Just a heads up that the
>>split queue fails on a patch with no author/date/subject as follows:
>>
>>[...]
>>git am of percpu-rwsem-compilefix.patch failed.
>>
>>This "treercu-use-simple-waitqueue.patch" has the exact same problem.
>>
>>Note that I'm using git directly, and not quilt -- which is more
>>strict in what it will accept, hence it catches these kinds of things.
>
> I just fixed up those two. "git quiltimport" works now.
>

Where did you fix these up? Can we have access?

Thanks

John
