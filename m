Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753756AbaBLTd4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 14:33:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17404 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752013AbaBLTdz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 14:33:55 -0500
Date: Wed, 12 Feb 2014 14:33:34 -0500
From: Luiz Capitulino <lcapitulino@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, mtosatti@redhat.com, mgorman@suse.de,
        aarcange@redhat.com, riel@redhat.com
Subject: Re: [PATCH 0/4] hugetlb: add hugepagesnid= command-line option
Message-ID: <20140212143334.76850251@redhat.com>
In-Reply-To: <20140212023711.GT11821@two.firstfloor.org>
References: <1392053268-29239-1-git-send-email-lcapitulino@redhat.com>
 <20140211211732.GS11821@two.firstfloor.org>
 <20140211163108.3136d55a@redhat.com>
 <20140212023711.GT11821@two.firstfloor.org>
Organization: Red Hat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Feb 2014 03:37:11 +0100
Andi Kleen <andi@firstfloor.org> wrote:

> > The real syntax is hugepagesnid=nid,nr-pages,size. Which looks straightforward
> > to me. I honestly can't think of anything better than that, but I'm open for
> > suggestions.
> 
> hugepages_node=nid:nr-pages:size,... ? 

Looks good, I'll consider using it for v2.
