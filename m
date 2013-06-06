Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757701Ab3FFH5w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 03:57:52 -0400
Received: from mx2.parallels.com ([199.115.105.18]:54930 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754580Ab3FFH5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 03:57:50 -0400
Message-ID: <51B04139.8060908@parallels.com>
Date: Thu, 6 Jun 2013 11:58:49 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Glauber Costa <glommer@openvz.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        <linux-kernel@vger.kernel.org>, <cgroups@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, <devel@openvz.org>
Subject: Re: [PATCH v7 00/11] per-cgroup cpu-stat
References: <1369825402-31046-1-git-send-email-glommer@openvz.org> <20130606014929.GS10693@mtj.dyndns.org>
In-Reply-To: <20130606014929.GS10693@mtj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2013 05:49 AM, Tejun Heo wrote:
> I generally agree with the approach but which tree is it based on?
> Can you please let me know the base commit so that I can review the
> series properly?
last week's -tip/master
