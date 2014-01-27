Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146AbaA0Rsp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 12:48:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9205 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753689AbaA0Rsn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 12:48:43 -0500
Date: Mon, 27 Jan 2014 18:48:58 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] wait*() induced tasklist_lock starvation
Message-ID: <20140127174858.GD32450@redhat.com>
References: <alpine.DEB.2.02.1401261500250.5335@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1401261500250.5335@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On 01/26, David Rientjes wrote:
>
> Or is it just
> another case of tasklist_lock problems that needs a major overhaul?

All I can say right now is: I'm afraid yes...

David, sorry, currently I can't even read your email carefully,
I'll try to return in a couple of days.

Oleg.

