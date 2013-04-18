Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964949Ab3DRAcK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 20:32:10 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:55590 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935285Ab3DRAcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 20:32:07 -0400
Date: Wed, 17 Apr 2013 17:32:03 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Will Huck <will.huckk@gmail.com>
cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org, Christoph Lameter <cl@linux.com>,
        Behan Webster <behanw@converseincode.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] slab: Remove unnecessary __builtin_constant_p()
In-Reply-To: <516F3B30.30307@gmail.com>
Message-ID: <alpine.DEB.2.02.1304171731410.26200@chino.kir.corp.google.com>
References: <1366225776.8817.28.camel@pippen.local.home> <516F3B30.30307@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Apr 2013, Will Huck wrote:

> In normal case, builtin_constant_p() is used for what?
> 

http://gcc.gnu.org/onlinedocs/
