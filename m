Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738AbaFEUzd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 16:55:33 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:63745 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471AbaFEUzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 16:55:31 -0400
Date: Thu, 5 Jun 2014 13:55:28 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Oleg Drokin <green@linuxhacker.ru>
cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Cody P Schafer <cody@linux.vnet.ibm.com>,
        Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-doc@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: Re: [patch v2] mm, pcp: allow restoring percpu_pagelist_fraction
 default
In-Reply-To: <FB428F94-91FA-4E4F-8DA3-060C3C41F261@linuxhacker.ru>
Message-ID: <alpine.DEB.2.02.1406051354420.18119@chino.kir.corp.google.com>
References: <1399166883-514-1-git-send-email-green@linuxhacker.ru> <alpine.DEB.2.02.1406021837490.13072@chino.kir.corp.google.com> <B549468A-10FC-4897-8720-7C9FEC6FD03A@linuxhacker.ru> <alpine.DEB.2.02.1406022056300.20536@chino.kir.corp.google.com>
 <2C763027-307F-4BC0-8C0A-7E3D5957A4DA@linuxhacker.ru> <alpine.DEB.2.02.1406031819580.8682@chino.kir.corp.google.com> <85AFB547-D3A1-4818-AD82-FF90909775D2@linuxhacker.ru> <alpine.DEB.2.02.1406041734150.17045@chino.kir.corp.google.com>
 <FB428F94-91FA-4E4F-8DA3-060C3C41F261@linuxhacker.ru>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jun 2014, Oleg Drokin wrote:

> Minor nitpick I guess, but ret cannot be anything but 0 here I think (until somebody changes the way proc_dointvec_minmax for write=true operates)?
> 

We need to return 0 regardless of whether proc_dointvec_minmax() changes 
in the future, the patch is correct.
