Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751760Ab3LLL2L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 06:28:11 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:37421 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423Ab3LLL2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 06:28:08 -0500
X-AuditID: cbfec7f5-b7fd16d000007299-c5-52a99dc665f3
Message-id: <52A99DC4.9000704@samsung.com>
Date: Thu, 12 Dec 2013 12:28:04 +0100
From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130330
 Thunderbird/17.0.5
MIME-version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] kernel/locking: mutex: simplify access to the first entry
 in the wait-list
References: <1386841541-32244-1-git-send-email-andrzej.p@samsung.com>
 <20131212095320.GE21999@twins.programming.kicks-ass.net>
In-reply-to: <20131212095320.GE21999@twins.programming.kicks-ass.net>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPLMWRmVeSWpSXmKPExsVy+t/xK7rH5q4MMti9jdHibNMbdovLu+aw
	Waw9cpfd4tKBBUwWx3sPMDmwemxeoeXxft9VNo++LasYPT5vkgtgieKySUnNySxLLdK3S+DK
	+NY7hbXgF3PFrjUnWBoYlzJ3MXJySAiYSHyZvAnKFpO4cG89WxcjF4eQwFJGiScLV7FDOJ8Z
	JU6vvcEIUsUroCWx+XkDUBUHB4uAqsTpM7YgYTYBY4m9BzvASkQFwiSmvr3DBlEuKPFj8j0W
	EFtEQFNiZdt9sAXMArMYJY5/+AO2WVggUeLAiTdQmxsYJTYuWQDWwSngKnH7+VR2EJtZwFpi
	5aRtjBC2vMTmNW+ZJzACjUFYMgtJ2SwkZQsYmVcxiqaWJhcUJ6XnGukVJ+YWl+al6yXn525i
	hATy1x2MS49ZHWIU4GBU4uF9cXBFkBBrYllxZe4hRgkOZiURXpfUlUFCvCmJlVWpRfnxRaU5
	qcWHGJk4OKUaGE09vnp+eJ9e43bg+7OHF27Vz2+aGf3Hxk34xakda1xPijzyWLnHqcz+6Gum
	SVfdRDfl5ixcY9B6U/DP7u5lwoZt/5bI/75zPoPx7d0iXx9/3y1hUs02Kk8S7xWUfGtc9GTn
	xPKDX0JuC80X9JqzZGbd2mnLuyc9ltglKvMyfmaqPXO0l2cswx4lluKMREMt5qLiRADDTq78
	QgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

W dniu 12.12.2013 10:53, Peter Zijlstra pisze:
> On Thu, Dec 12, 2013 at 10:45:41AM +0100, Andrzej Pietrasiewicz wrote:
>> Use list_first_entry instead of explicitly accessing the first entry
>> with "head".next. The comment one line above becomes obsolete.
>>
>> Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
>> Signed-off-by: Kyungmin Park <andrzej.p@samsung.com>
>
> This is an invalid sign-off trail.
>
Right... Thanks for spotting this. I will correct it and resubmit.

AP
