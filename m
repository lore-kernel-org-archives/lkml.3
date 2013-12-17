Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932362Ab3LQSrQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 13:47:16 -0500
Received: from mail-we0-f180.google.com ([74.125.82.180]:50918 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932332Ab3LQSrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 13:47:11 -0500
MIME-Version: 1.0
In-Reply-To: <CAKz8sYWmmmdwKTKUGdoyaMD_v9_7yQydG+UNAb2r-KoO4L+6Ng@mail.gmail.com>
References: <CAKz8sYWmmmdwKTKUGdoyaMD_v9_7yQydG+UNAb2r-KoO4L+6Ng@mail.gmail.com>
From: David Timothy Strauss <david@davidstrauss.net>
Date: Tue, 17 Dec 2013 10:46:50 -0800
Message-ID: <CAKz8sYW2gSt=rJTksqrHjcGjUttsJms1CkmtG_zpBn6FvB_-0w@mail.gmail.com>
Subject: Re: NUMA, migrate/N, and tuned-adm
To: Mel Gorman <mgorman@suse.de>, Ingo Molnar <mingo@kernel.org>,
        Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 17, 2013 at 10:10 AM, David Timothy Strauss
<david@davidstrauss.net> wrote:
>  * Splitting the system with cpuset into management tasks (6 virtual
> cores) and workload tasks (18 virtual cores) with
> sched_relax_domain_level=2. This is based on recommendations for NUMA
> systems in the cpuset man page.

I actually meant logical cores, not virtual cores here.
