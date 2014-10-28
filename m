Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752971AbaJ1EOa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 00:14:30 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:46315 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301AbaJ1EO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 00:14:26 -0400
Date: Mon, 27 Oct 2014 21:14:12 -0700
From: Darren Hart <dvhart@infradead.org>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] asus-nb-wmi: Add wapf4 quirk for the X550VB
Message-ID: <20141028041412.GA52511@vmdeb7>
References: <20141022123252.GC1876@redhat.com>
 <20141025051116.GA53394@vmdeb7>
 <20141026102354.GA2588@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141026102354.GA2588@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 26, 2014 at 11:23:55AM +0100, Stanislaw Gruszka wrote:
> X550VB as many others Asus laptops need wapf4 quirk to make RFKILL
> switch be functional. Otherwise system boots with wireless card
> disabled and is only possible to enable it by suspend/resume.
> 
> Bug report:
> http://bugzilla.redhat.com/show_bug.cgi?id=1089731#c23
> 
> Reported-and-tested-by: Vratislav Podzimek <vpodzime@redhat.com>
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

Queued, thanks Stanislaw.

-- 
Darren Hart
Intel Open Source Technology Center
