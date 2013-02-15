Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564Ab3BOHAa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 02:00:30 -0500
Received: from mx0.parallels.com ([199.115.104.20]:45867 "EHLO
	mx0.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683Ab3BOHA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 02:00:29 -0500
Message-ID: <511DDD25.9030401@parallels.com>
Date: Fri, 15 Feb 2013 11:00:53 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Serge Hallyn <serge.hallyn@ubuntu.com>, <linux-kernel@vger.kernel.org>,
        <containers@lists.linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kernel: allow reboots from user_ns
References: <1360843000-31228-1-git-send-email-glommer@parallels.com> <20130214142745.GA4470@sergelap> <511CF51C.6050504@parallels.com> <87wqubc58b.fsf@xmission.com>
In-Reply-To: <87wqubc58b.fsf@xmission.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14/2013 06:58 PM, Eric W. Biederman wrote:
>> I didn't see that, and using Linus' master my stop container scripts
>> > stopped working after I started using Eric's userns...
> The patch has been sitting in my for-next branch for quite a while
> just waiting for the merge window.
> 
> Eric
Fine by me.

