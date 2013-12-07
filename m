Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201Ab3LGJQt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Dec 2013 04:16:49 -0500
Received: from shutemov.name ([204.155.152.216]:52262 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752683Ab3LGJQr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Dec 2013 04:16:47 -0500
Date: Sat, 7 Dec 2013 10:21:17 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org, kirill.shutemov@linux.intel.com
Subject: Re: oops in pgtable_trans_huge_withdraw
Message-ID: <20131207082117.GA17914@shutemov.name>
References: <20131206210254.GA7962@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131206210254.GA7962@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 06, 2013 at 04:02:54PM -0500, Dave Jones wrote:
> I've spent a few days enhancing trinity's use of mmap's, trying to make it
> reproduce https://lkml.org/lkml/2013/12/4/499  
> Instead, I hit this.. related ?

Could you try this:

https://lkml.org/lkml/2013/12/4/499

-- 
 Kirill A. Shutemov
