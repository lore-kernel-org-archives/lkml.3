Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751641AbaFEM3q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 08:29:46 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:57971 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390AbaFEM3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 08:29:44 -0400
Date: Thu, 5 Jun 2014 14:29:40 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Igor Mammedov <imammedo@redhat.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        x86@kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [PATCH v5 0/4] x86: fix hang when AP bringup is too slow
Message-ID: <20140605122940.GA1392@gmail.com>
References: <1399322991-19329-1-git-send-email-imammedo@redhat.com>
 <20140604152155.08e15821@nial.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140604152155.08e15821@nial.usersys.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Igor Mammedov <imammedo@redhat.com> wrote:

> > Series also fixes 3 bugs found during testing CPU bringup
> > failure case.
> 
> since 3.16 merge window is open now,
> ping

Mind resending the remaining patches on top of Linus's latest, which I 
suppose has one of the fixes already included via Rafael's tree?

Thanks,

	Ingo
