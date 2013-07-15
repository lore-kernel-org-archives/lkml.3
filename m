Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757302Ab3GOOK3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 10:10:29 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:34341 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757136Ab3GOOK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 10:10:28 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        David Gibson <david@gibson.dropbear.id.au>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Joonsoo Kim <js1304@gmail.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: [PATCH 0/9] mm, hugetlb: clean-up and possible bug fix
In-Reply-To: <1373881967-16153-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1373881967-16153-1-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Notmuch/0.15.2+167~g5306b2b (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
Date: Mon, 15 Jul 2013 19:40:16 +0530
Message-ID: <871u6zkj7b.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071514-5140-0000-0000-000003853C6A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joonsoo Kim <iamjoonsoo.kim@lge.com> writes:

> First 5 patches are almost trivial clean-up patches.
>
> The others are for fixing three bugs.
> Perhaps, these problems are minor, because this codes are used
> for a long time, and there is no bug reporting for these problems.
>
> These patches are based on v3.10.0 and
> passed sanity check of libhugetlbfs.

does that mean you had run with libhugetlbfs test suite ?
 
-aneesh

