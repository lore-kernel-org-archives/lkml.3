Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483Ab3AUWya (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 17:54:30 -0500
Received: from csamuel.org ([74.50.50.137]:38477 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751625Ab3AUWy3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 17:54:29 -0500
Message-ID: <50FDC712.1030908@csamuel.org>
Date: Tue, 22 Jan 2013 09:54:10 +1100
From: Chris Samuel <chris@csamuel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: linux-kernel@vger.kernel.org, dhowells@redhat.com,
        Josh Boyer <jwboyer@gmail.com>
Subject: Re: [PATCH] MODSIGN: Warn when module signature checking fails
References: <50F67D75.9080508@csamuel.org> <87a9s3xw9g.fsf@rustcorp.com.au>
In-Reply-To: <87a9s3xw9g.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

/* Please CC me, I'm not on LKML */

On 21/01/13 10:36, Rusty Russell wrote:

> We have errnos for a reason; let's not pollute the kernel logs.  That's
> a userspace job.

Fair enough.

> This part is OK, but I'll add mod->name to the printk.

Sounds good.

> How's this:

Looks fine, modulo the lack of mod->name as Stephen mentioned.

cheers,
Chris
-- 
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC
