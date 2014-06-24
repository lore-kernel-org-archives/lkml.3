Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095AbaFXGix (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 02:38:53 -0400
Received: from gate.crashing.org ([63.228.1.57]:35180 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751823AbaFXGiw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 02:38:52 -0400
Message-ID: <1403591911.4587.162.camel@pasglop>
Subject: Re: [PATCH] powerpc: Fix build warning
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        Vincent Guittot <vincent.guittot@linaro.org>
Date: Tue, 24 Jun 2014 16:38:31 +1000
In-Reply-To: <53A91449.6010701@roeck-us.net>
References: <1402677499-28289-1-git-send-email-linux@roeck-us.net>
	 <1403584501.4587.153.camel@pasglop> <53A90718.4050401@roeck-us.net>
	 <1403588053.4587.160.camel@pasglop> <53A91449.6010701@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-06-23 at 23:01 -0700, Guenter Roeck wrote:
> I thought that only happens if a const is dropped, but maybe not.
> 
> Sigh. Much easier to break something than to fix it. That would mean
> to get approval
> from at least three maintainers, and all that to get rid of a warning.
> I don't
> really have time for that. Let's just forget about it and live with
> the warning.

Well you have my tentative approval :) And trivial ones like that don't
really need the respective maintainers to respond really, I forget
regularly and they still go upstream.

Cheers,
Ben.


