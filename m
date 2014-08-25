Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932976AbaHYRQN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 13:16:13 -0400
Received: from eddie.linux-mips.org ([148.251.95.138]:41842 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932187AbaHYRQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 13:16:12 -0400
Date: Mon, 25 Aug 2014 19:16:00 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: Max Filippov <jcmvbkbc@gmail.com>
Cc: linux-xtensa@linux-xtensa.org, Chris Zankel <chris@zankel.net>,
        Marc Gauthier <marc@cadence.com>, linux-mm@kvack.org,
        linux-arch@vger.kernel.org, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>,
        Steven Hill <Steven.Hill@imgtec.com>
Subject: Re: [PATCH v4 0/2] mm/highmem: make kmap cache coloring aware
Message-ID: <20140825171600.GH25892@linux-mips.org>
References: <1406941899-19932-1-git-send-email-jcmvbkbc@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406941899-19932-1-git-send-email-jcmvbkbc@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 02, 2014 at 05:11:37AM +0400, Max Filippov wrote:

> this series adds mapping color control to the generic kmap code, allowing
> architectures with aliasing VIPT cache to use high memory. There's also
> use example of this new interface by xtensa.

I haven't actually ported this to MIPS but it certainly appears to be
the right framework to get highmem aliases handled on MIPS, too.

Though I still consider increasing PAGE_SIZE to 16k the preferable
solution because it will entirly do away with cache aliases.

Thanks,

  Ralf
