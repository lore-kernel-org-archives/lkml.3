Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205AbaFBXsu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 19:48:50 -0400
Received: from mail-ig0-f174.google.com ([209.85.213.174]:50073 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753126AbaFBXss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 19:48:48 -0400
Date: Mon, 2 Jun 2014 16:48:46 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Hugh Dickins <hughd@google.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        cgroups@vger.kernel.org
Subject: Re: [patch] mm, memcg: periodically schedule when emptying page
 list
In-Reply-To: <alpine.LSU.2.11.1406021637170.5627@eggly.anvils>
Message-ID: <alpine.DEB.2.02.1406021648260.8495@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1406021612550.6487@chino.kir.corp.google.com> <alpine.LSU.2.11.1406021637170.5627@eggly.anvils>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Jun 2014, Hugh Dickins wrote:

> Why not just move that cond_resched() down below the if/else?
> No need to test need_resched() separately, and this page is not busy.
> 

Would you like to propose your version from our kernel instead?
