Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757986Ab3BVQUX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 11:20:23 -0500
Received: from mx0.parallels.com ([199.115.104.20]:40466 "EHLO
	mx0.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757306Ab3BVQUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 11:20:19 -0500
Message-ID: <51279ADA.4060602@parallels.com>
Date: Fri, 22 Feb 2013 20:20:42 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: <linux-mm@kvack.org>, <cgroups@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH] slub: correctly bootstrap boot caches
References: <1361529030-17462-1-git-send-email-glommer@parallels.com> <51275364.3010908@jp.fujitsu.com>
In-Reply-To: <51275364.3010908@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2013 03:15 PM, Kamezawa Hiroyuki wrote:
> Tested-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu,com>
I took the liberty to keep this, even with changes in the patch
because I didn't change anything related to the root cause of the
problem.

Let me know if you object.

