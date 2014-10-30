Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760858AbaJ3TrL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 15:47:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755306AbaJ3TrK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 15:47:10 -0400
Message-ID: <54529504.3040101@redhat.com>
Date: Thu, 30 Oct 2014 15:44:04 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Iulia Manda <iulia.manda21@gmail.com>, linux-kernel@vger.kernel.org
CC: mingo@redhat.com, peterz@infradead.org, mgorman@suse.de
Subject: Re: [PATCH] kernel: Refactor task_struct to use numa_faults instead
 of numa_* pointers
References: <20141030193817.GA17859@winterfell>
In-Reply-To: <20141030193817.GA17859@winterfell>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/30/2014 03:38 PM, Iulia Manda wrote:
> This patch simplifies task_struct by removing the four numa_* pointers
> in the same array and replacing them with the array pointer. By doing this,
> the size of task_struct is reduced.
> 
> A new parameter is added to the task_faults_idx function so that it can return
> an index to the correct offset, corresponding with the old precalculated
> pointers.
> 
> All of the code in sched/ that depended on task_faults_idx and numa_* was
> changed in order to match the new logic.
> 
> Signed-off-by: Iulia Manda <iulia.manda21@gmail.com>

Acked-by: Rik van Riel <riel@redhat.com>

