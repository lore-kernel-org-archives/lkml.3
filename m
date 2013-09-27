Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050Ab3I0RyK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 13:54:10 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:22686 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470Ab3I0RyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 13:54:07 -0400
Date: Fri, 27 Sep 2013 19:53:53 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Jingoo Han <jg1.han@samsung.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernel: replace strict_strto*() with kstrto*()
Message-ID: <20130927195353.3643398a@endymion.delvare>
In-Reply-To: <CAErSpo51GFB+yCuaHrwBqWjHxd0GboHgvWGov5pj4V6aGPfQHg@mail.gmail.com>
References: <000401ce86b7$0463f580$0d2be080$@samsung.com>
	<CAErSpo51GFB+yCuaHrwBqWjHxd0GboHgvWGov5pj4V6aGPfQHg@mail.gmail.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.18; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

On Fri, 27 Sep 2013 09:50:39 -0600, Bjorn Helgaas wrote:
> There's some indication that this change might have broken handling of
> signed types.  See
> https://lists.ozlabs.org/pipermail/linuxppc-dev/2013-September/111758.html
> and https://bugzilla.kernel.org/show_bug.cgi?id=61811.

It seems this is hurting more users than I would have expected, and
people are spending significant amounts of time to figure out what the
root cause to their problem is. May I suggest that my fix should find
its way to Linus' tree rather sooner than later?

Thanks,
-- 
Jean Delvare
