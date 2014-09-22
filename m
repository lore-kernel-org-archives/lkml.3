Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442AbaIVIVn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 04:21:43 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:51130 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753166AbaIVIVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 04:21:39 -0400
X-Original-SENDERIP: 10.177.220.159
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Mon, 22 Sep 2014 17:22:03 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, cl@linux.com, penberg@kernel.org,
        rdunlap@infradead.org, rientjes@google.com
Subject: Re: + mm-slab_common-commonize-slab-merge-logic.patch added to -mm
 tree
Message-ID: <20140922082203.GA11825@js1304-P5Q-DELUXE>
References: <541cb039.GkGFlIDKO1+jpDW0%akpm@linux-foundation.org>
 <20140922003245.GA28902@js1304-P5Q-DELUXE>
 <20140922004841.7f1e9c60.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140922004841.7f1e9c60.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 12:48:41AM -0700, Andrew Morton wrote:
> On Mon, 22 Sep 2014 09:32:45 +0900 Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:
> 
> > Hello, Andrew.
> > 
> > This patch has build failure problem if CONFIG_SLUB.
> > Detailed information and fix is in following patch.
> > 
> 
> Pleeeeeze be careful with the email headers?  I happened to see this
> email on lkml, wasn't cc'ed.

Opps... Sorry.
Do you want to resend?

> 
> I assume there's something in the mm-commits headers which is causing
> this to happen, but I don't know what.  I expect a busted email client
> is involved.
> 
> This:
> 
> From: akpm@linux-foundation.org
> To: iamjoonsoo.kim@lge.com, cl@linux.com, penberg@kernel.org, rdunlap@infradead.org, rientjes@google.com, mm-commits@vger.kernel.org
> Reply-To: linux-kernel@vger.kernel.org
> Subject: + mm-slab_common-commonize-slab-merge-logic.patch added to -mm tree

I think that it is caused by 'Reply-To' header. There is some
explanation about it on
https://www.gnu.org/software/emacs/manual/html_node/emacs/Mail-Headers.html

‘Reply-to’
An address to which replies should be sent, instead of ‘From’. This is
used if, for some reason, your ‘From’ address cannot receive replies. 

In this case, your address in 'From' doesn't disappears in my Reply-All.

Thanks.
