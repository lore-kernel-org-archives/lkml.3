Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752997Ab3GHUHf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 16:07:35 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:10304 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750Ab3GHUHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 16:07:33 -0400
Message-ID: <51DB1BA0.8020402@hp.com>
Date: Mon, 08 Jul 2013 16:05:52 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Paul Moore <paul@paul-moore.com>
CC: Eric Paris <eparis@parisplace.org>, Stephen Smalley <sds@tycho.nsa.gov>,
        James Morris <james.l.morris@oracle.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>, selinux@tycho.nsa.gov
Subject: Re: [PATCH 1/2 v5] SELinux: Reduce overhead of mls_level_isvalid()
 function call
References: <1370886908-65256-1-git-send-email-Waiman.Long@hp.com> <51B70EE4.5030209@tycho.nsa.gov> <51D6FE08.8030904@hp.com> <2187595.WquvNei6zx@sifl>
In-Reply-To: <2187595.WquvNei6zx@sifl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/2013 12:30 PM, Paul Moore wrote:
> On Friday, July 05, 2013 01:10:32 PM Waiman Long wrote:
>> On 06/11/2013 07:49 AM, Stephen Smalley wrote:
>>> On 06/10/2013 01:55 PM, Waiman Long wrote:
> ...
>
>>>> Signed-off-by: Waiman Long<Waiman.Long@hp.com>
>>> Acked-by:  Stephen Smalley<sds@tycho.nsa.gov>
>> Thank for the Ack. Will that patch go into v3.11?
> [NOTE: I add the SELinux list to the CC line, for future reference, be sure to
> send your SELinux patches there.]
>
> Your patch looked reasonable to me and Stephen ACK'd it so I went ahead and
> pulled the 1/2 patch into my lblnet-next tree.  It is probably an abuse of the
> system, but as you noted it in the description, it does have an impact on
> socket creation so it isn't completely unrelated ;)
>
> If you don't want me to include your patch let me know and I'll drop it.

Sure. I would like to have my patch included. Thank for letting me know.

Regards,
Longman
