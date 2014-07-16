Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752059AbaGPTiv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 15:38:51 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:60555 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbaGPTis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 15:38:48 -0400
Date: Wed, 16 Jul 2014 12:37:04 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: David Rientjes <rientjes@google.com>
cc: Vlastimil Babka <vbabka@suse.cz>, Bob Liu <bob.liu@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch v2] mm, tmp: only collapse hugepages to nodes with affinity
 for zone_reclaim_mode
In-Reply-To: <53C69E92.70608@suse.cz>
Message-ID: <alpine.LSU.2.11.1407161234160.3956@eggly.anvils>
References: <alpine.DEB.2.02.1407141807030.8808@chino.kir.corp.google.com> <alpine.DEB.2.02.1407151712520.12279@chino.kir.corp.google.com> <53C5D3D2.8080000@oracle.com> <53C69E92.70608@suse.cz>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I shall worry less if you change the Subject from "mm, tmp:" to "mm, thp:"

Hugh :)
