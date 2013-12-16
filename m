Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812Ab3LPQw7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 11:52:59 -0500
Received: from b232-35.smtp-out.amazonses.com ([199.127.232.35]:14053 "EHLO
	b232-35.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754406Ab3LPQw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 11:52:58 -0500
Date: Mon, 16 Dec 2013 16:52:57 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Dave Hansen <dave@sr71.net>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Pravin B Shelar <pshelar@nicira.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [RFC][PATCH 1/7] mm: print more details for bad_page()
In-Reply-To: <20131213235904.D69C09F7@viggo.jf.intel.com>
Message-ID: <00000142fc5326bf-37eaf439-1c10-448f-9cd3-8137290680ca-000000@email.amazonses.com>
References: <20131213235903.8236C539@viggo.jf.intel.com> <20131213235904.D69C09F7@viggo.jf.intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.127.232.35
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Dec 2013, Dave Hansen wrote:

> This way, the messages will show specifically why the page was
> bad, *specifically* which flags it is complaining about, if it
> was a page flag combination which was the problem.

Yes this would have been helpful in the past for me.

Reviewed-by: Christoph Lameter <cl@linux.com>
