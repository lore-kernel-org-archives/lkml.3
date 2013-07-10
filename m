Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063Ab3GJCA2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 22:00:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23123 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752372Ab3GJCA1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 22:00:27 -0400
Date: Tue, 9 Jul 2013 21:59:36 -0400
From: Dave Jones <davej@redhat.com>
To: "Michael L. Semon" <mlsemon35@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        d.hatayama@jp.fujitsu.com, akpm@linux-foundation.org
Subject: Re: [REGRESSION] x86 vmalloc issue from recent 3.10.0+ commit
Message-ID: <20130710015936.GC13855@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"Michael L. Semon" <mlsemon35@gmail.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	d.hatayama@jp.fujitsu.com, akpm@linux-foundation.org
References: <51DCBE24.3030406@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51DCBE24.3030406@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 09, 2013 at 09:51:32PM -0400, Michael L. Semon wrote:

 > kernel: [ 2580.395592] vmap allocation for size 20480 failed: use vmalloc=<size> to increase size.
 > kernel: [ 2580.395761] vmalloc: allocation failure: 16384 bytes

I was seeing a lot of these recently too.
(Though I also saw memory corruption afterwards possibly caused by
 a broken fallback path somewhere when that vmalloc fails)

http://comments.gmane.org/gmane.linux.kernel.mm/102895

	Dave

