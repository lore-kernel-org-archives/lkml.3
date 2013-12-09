Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932731Ab3LIPm2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 10:42:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48060 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760952Ab3LIPm1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 10:42:27 -0500
Date: Mon, 9 Dec 2013 10:42:11 -0500
From: Dave Jones <davej@redhat.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        kirill.shutemov@linux.intel.com
Subject: Re: oops in pgtable_trans_huge_withdraw
Message-ID: <20131209154211.GA15701@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"Kirill A. Shutemov" <kirill@shutemov.name>,
	Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
	kirill.shutemov@linux.intel.com
References: <20131206210254.GA7962@redhat.com>
 <20131207082117.GA17914@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131207082117.GA17914@shutemov.name>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 07, 2013 at 10:21:17AM +0200, Kirill A. Shutemov wrote:
 > On Fri, Dec 06, 2013 at 04:02:54PM -0500, Dave Jones wrote:
 > > I've spent a few days enhancing trinity's use of mmap's, trying to make it
 > > reproduce https://lkml.org/lkml/2013/12/4/499  
 > > Instead, I hit this.. related ?
 > 
 > Could you try this:
 > 
 > https://lkml.org/lkml/2013/12/4/499

I thought I had tried that on Friday, but apparently I had booted the wrong kernel.
This does seem to be the same problem. I can't reproduce the failure any more
with this patch applied.

thanks,

	Dave

