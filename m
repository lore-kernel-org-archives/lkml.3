Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389Ab3CRQFn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 12:05:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59494 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751431Ab3CRQFm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 12:05:42 -0400
Date: Mon, 18 Mar 2013 17:03:23 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Lucas De Marchi <lucas.de.marchi@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>, david@gibson.dropbear.id.au,
        Kees Cook <keescook@chromium.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Feng Hong <hongfeng@marvell.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>
Subject: Re: [PATCH 0/2] finx argv_split() vs sysctl race
Message-ID: <20130318160323.GA10981@redhat.com>
References: <20130313174705.GB28083@redhat.com> <20130314152819.7fb1242b493e8bad2d34671b@linux-foundation.org> <20130315163916.GA31995@redhat.com> <20130316202327.GA18613@redhat.com> <20130316203221.GT11268@two.firstfloor.org> <20130316204539.GA19462@redhat.com> <20130316205634.GU11268@two.firstfloor.org> <20130316212351.GA21190@redhat.com> <20130316215440.GV11268@two.firstfloor.org> <20130317141555.GA25236@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130317141555.GA25236@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/17, Oleg Nesterov wrote:
>
> Ah, I didn't mean the patch makes sense because of optimization. My
> point was, we can fix the race without making this code worse (in fact
> it tries to make the code better but this is subjective).

OK, I am stupid.  argv_free() passes the wrong poiinter to kfree().
I am sendind v2 in reply to 1/2, sorry for noise.

Oleg.

