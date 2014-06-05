Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054AbaFENMs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 09:12:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37609 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751877AbaFENMr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 09:12:47 -0400
Date: Thu, 5 Jun 2014 15:12:37 +0200
From: Igor Mammedov <imammedo@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        x86@kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [PATCH v5 0/4] x86: fix hang when AP bringup is too slow
Message-ID: <20140605151237.7b96332c@nial.usersys.redhat.com>
In-Reply-To: <20140605122940.GA1392@gmail.com>
References: <1399322991-19329-1-git-send-email-imammedo@redhat.com>
	<20140604152155.08e15821@nial.usersys.redhat.com>
	<20140605122940.GA1392@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Jun 2014 14:29:40 +0200
Ingo Molnar <mingo@kernel.org> wrote:

> 
> * Igor Mammedov <imammedo@redhat.com> wrote:
> 
> > > Series also fixes 3 bugs found during testing CPU bringup
> > > failure case.
> > 
> > since 3.16 merge window is open now,
> > ping
> 
> Mind resending the remaining patches on top of Linus's latest, which I 
> suppose has one of the fixes already included via Rafael's tree?
Sure, I'll rebase and repost it today.

> 
> Thanks,
> 
> 	Ingo

