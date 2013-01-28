Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757386Ab3A1OlZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 09:41:25 -0500
Received: from mx2.parallels.com ([64.131.90.16]:38247 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756969Ab3A1OlW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 09:41:22 -0500
Message-ID: <51068E23.5040000@parallels.com>
Date: Mon, 28 Jan 2013 18:41:39 +0400
From: Lord Glauber Costa of Sealand <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Aristeu Rozanski <aris@redhat.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
        <linux-fsdevel@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH review 2/6] userns: Allow any uid or gid mappings that
 don't overlap.
References: <87ehh8it9s.fsf@xmission.com> <87zjzwhegj.fsf@xmission.com> <20130128142816.GU17632@redhat.com>
In-Reply-To: <20130128142816.GU17632@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Mr. Someone.

On 01/28/2013 06:28 PM, Aristeu Rozanski wrote:
> On Fri, Jan 25, 2013 at 06:21:00PM -0800, Eric W. Biederman wrote:
>> When I initially wrote the code for /proc/<pid>/uid_map.  I was lazy
>> and avoided duplicate mappings by the simple expedient of ensuring the
>> first number in a new extent was greater than any number in the
>> previous extent.
>>
>> Unfortunately that precludes a number of valid mappings, and someone
>> noticed and complained.  So use a simple check to ensure that ranges
>> in the mapping extents don't overlap.
> 
> Acked-by: Someone <aris@redhat.com>
> 

Documentation/SubmittingPatches:

"then you just add a line saying

        Signed-off-by: Random J Developer <random@developer.example.org>

using your real name (sorry, no pseudonyms or anonymous contributions.)"

I know how it feels, but that is how it goes. You'll have to change that.

