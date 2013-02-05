Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963Ab3BEPHb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 10:07:31 -0500
Received: from a194-210.smtp-out.amazonses.com ([199.255.194.210]:54999 "EHLO
	a194-210.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755667Ab3BEPH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 10:07:28 -0500
X-Greylist: delayed 560 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Feb 2013 10:07:28 EST
Date: Tue, 5 Feb 2013 14:58:07 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Steven Rostedt <rostedt@goodmis.org>
cc: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH] slob: Check for NULL pointer before calling ctor()
In-Reply-To: <1360073811.27007.13.camel@gandalf.local.home>
Message-ID: <0000013caadd2e2f-3ca39b5e-cc18-4a38-9485-d505a89098af-000000@email.amazonses.com>
References: <1358442826.23211.18.camel@gandalf.local.home> <1360073811.27007.13.camel@gandalf.local.home>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.194.210
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Feb 2013, Steven Rostedt wrote:

> Ping?

Obviously correct.

Acked-by: Christoph Lameter <cl@linux.com>
