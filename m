Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932328Ab3INSQP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 14:16:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31126 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932289Ab3INSQO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 14:16:14 -0400
Date: Sat, 14 Sep 2013 20:10:01 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steve Grubb <sgrubb@redhat.com>
Cc: linux-audit@redhat.com, Richard Guy Briggs <rgb@redhat.com>,
        linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Eric Paris <eparis@redhat.com>
Subject: Re: audit looks unmaintained? [was: Re: [PATCH 11/12] pid: rewrite
	task helper functions avoiding task->pid and task->tgid]
Message-ID: <20130914181001.GB24970@redhat.com>
References: <cover.1377032086.git.rgb@redhat.com> <20130908155435.GC4663@redhat.com> <20130910172033.GA6585@redhat.com> <1759139.jak6GOp6Pt@x2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1759139.jak6GOp6Pt@x2>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13, Steve Grubb wrote:
>
> On Tuesday, September 10, 2013 07:20:33 PM Oleg Nesterov wrote:
> >
> > So, Steve, do you still think that patch was wrong? Attached below
> > just in case.
>
> I think this looks OK. If the task filter NACK's auditing the process, then
> clearing the flag is probably correct. I have design notes from back around the
> 2.6.7 kernel saying this was the intention.

Then I do not really understand your previous email... Nevermind ;)

> ACK.

Thanks. I'll resend this patch with your ack applied.

Oleg.

