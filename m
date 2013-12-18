Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196Ab3LRIvy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 03:51:54 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:38658 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751072Ab3LRIvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 03:51:52 -0500
X-Sasl-enc: UIjlrZsecosPZr+L9aoYq3rC/8exqEtFWRe9RKGlCeJL 1387356711
Message-ID: <52B16224.50006@iki.fi>
Date: Wed, 18 Dec 2013 10:51:48 +0200
From: Pekka Enberg <penberg@iki.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Dave Hansen <dave@sr71.net>, Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Pravin B Shelar <pshelar@nicira.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>, Pekka Enberg <penberg@kernel.org>
Subject: Re: [RFC][PATCH 0/7] re-shrink 'struct page' when SLUB is on.
References: <20131213235903.8236C539@viggo.jf.intel.com> <20131216160128.aa1f1eb8039f5eee578cf560@linux-foundation.org> <52AF9EB9.7080606@sr71.net>
In-Reply-To: <52AF9EB9.7080606@sr71.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2013 02:45 AM, Dave Hansen wrote:
> I'll do some testing and see if I can coax out any delta from the
> optimization myself.  Christoph went to a lot of trouble to put this
> together, so I assumed that he had a really good reason, although the
> changelogs don't really mention any.

IIRC it's commit 8a5ec0b ("Lockless (and preemptless) fastpaths for 
slub") that documents the performance gains.

The page alignment patches came later once we discovered that we broke 
the world...

                         Pekka
