Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759223Ab3IBU62 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 16:58:28 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:56321 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759020Ab3IBU6Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 16:58:25 -0400
Message-ID: <1378155503.1953.112.camel@joe-AO722>
Subject: Re: [PATCH] checkpatch: Make extern in .h prototypes quieter.
From: Joe Perches <joe@perches.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: David Howells <dhowells@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, hannes@stressinduktion.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>
Date: Mon, 02 Sep 2013 13:58:23 -0700
In-Reply-To: <CAMuHMdXMwnBqAM64yvhFNsbcnwOHRyN9c02GRyxATMwuMOKnUw@mail.gmail.com>
References: <9606.1378129893@warthog.procyon.org.uk>
	 <1378138904.1953.72.camel@joe-AO722>
	 <CAMuHMdXMwnBqAM64yvhFNsbcnwOHRyN9c02GRyxATMwuMOKnUw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-09-02 at 22:51 +0200, Geert Uytterhoeven wrote:
> I know it's not the subject of this patch, but shouldn't "extern prototypes"
> be "extern keywords"?

No, extern is required for variables.


