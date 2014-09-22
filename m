Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753084AbaIVHsp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 03:48:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46601 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894AbaIVHso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 03:48:44 -0400
Date: Mon, 22 Sep 2014 00:48:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: linux-kernel@vger.kernel.org, cl@linux.com, penberg@kernel.org,
        rdunlap@infradead.org, rientjes@google.com
Subject: Re: + mm-slab_common-commonize-slab-merge-logic.patch added to -mm
 tree
Message-Id: <20140922004841.7f1e9c60.akpm@linux-foundation.org>
In-Reply-To: <20140922003245.GA28902@js1304-P5Q-DELUXE>
References: <541cb039.GkGFlIDKO1+jpDW0%akpm@linux-foundation.org>
	<20140922003245.GA28902@js1304-P5Q-DELUXE>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Sep 2014 09:32:45 +0900 Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:

> Hello, Andrew.
> 
> This patch has build failure problem if CONFIG_SLUB.
> Detailed information and fix is in following patch.
> 

Pleeeeeze be careful with the email headers?  I happened to see this
email on lkml, wasn't cc'ed.

I assume there's something in the mm-commits headers which is causing
this to happen, but I don't know what.  I expect a busted email client
is involved.

This:

From: akpm@linux-foundation.org
To: iamjoonsoo.kim@lge.com, cl@linux.com, penberg@kernel.org, rdunlap@infradead.org, rientjes@google.com, mm-commits@vger.kernel.org
Reply-To: linux-kernel@vger.kernel.org
Subject: + mm-slab_common-commonize-slab-merge-logic.patch added to -mm tree

