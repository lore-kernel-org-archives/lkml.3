Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536AbaIVQrn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 12:47:43 -0400
Received: from homie.mail.dreamhost.com ([208.97.132.208]:51376 "EHLO
	homiemail-a8.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754199AbaIVQrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 12:47:42 -0400
Message-ID: <1411404460.28679.12.camel@linux-t7sj.site>
Subject: Re: [PATCH] mm: Support compiling out madvise and fadvise
From: Davidlohr Bueso <dave@stgolabs.net>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org, linux-mm@kvack.org
Date: Mon, 22 Sep 2014 18:47:40 +0200
In-Reply-To: <20140922161109.GA25027@thin>
References: <20140922161109.GA25027@thin>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-09-22 at 09:11 -0700, Josh Triplett wrote:
> Many embedded systems will not need these syscalls, and omitting them
> saves space.  Add a new EXPERT config option CONFIG_ADVISE_SYSCALLS
> (default y) to support compiling them out.

general question: if a user chooses CONFIG_ADVISE_SYSCALLS=n (or any
config option related to tinyfication) and breaks the system/workload...
will that be acceptable for a kernel pov? In other words, what's the
degree of responsibility the user will have when choosing such builds?

Thanks,
Davidlohr

