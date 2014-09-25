Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763AbaIYKjm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 06:39:42 -0400
Received: from www.linutronix.de ([62.245.132.108]:32819 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414AbaIYKjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 06:39:40 -0400
Date: Thu, 25 Sep 2014 12:39:33 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: David Rientjes <rientjes@google.com>
cc: James Custer <jcuster@sgi.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH] x86: Allow 1GB pages to be SPECIAL similar to 2MB
In-Reply-To: <alpine.DEB.2.02.1409241504110.10785@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.10.1409251239030.4604@nanos>
References: <1411579143-10963-1-git-send-email-jcuster@sgi.com> <alpine.DEB.2.02.1409241504110.10785@chino.kir.corp.google.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Sep 2014, David Rientjes wrote:

> On Wed, 24 Sep 2014, James Custer wrote:
> 
> > 
> > Signed-off-by: James Custer <jcuster@sgi.com>
> 
> With no changelog to describe the motivation for this change or to specify 
> why it's required, I doubt you're going to get your patches merged by the 
> x86 maintainers.

Indeed. Was about to rant about this ...

	tglx
 
