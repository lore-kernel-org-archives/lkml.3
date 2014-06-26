Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697AbaFZCzO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 22:55:14 -0400
Received: from plane.gmane.org ([80.91.229.3]:51213 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752104AbaFZCzN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 22:55:13 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Gobinda Charan Maji <gobinda.cemk07@gmail.com>
Subject: Re: Stricter module param and sysfs permission checks
Date: Thu, 26 Jun 2014 02:54:59 +0000 (UTC)
Message-ID: <loom.20140626T044310-195@post.gmane.org>
References: <1394818263-29947-1-git-send-email-tytso@mit.edu> <1394818720.3253.1.camel@joe-AO722> <20140314180258.GA29201@thunk.org> <87y509scl3.fsf@rustcorp.com.au> <1395032434.2556.10.camel@joe-AO722> <1395041214.2556.17.camel@joe-AO722> <87zjkmr8w1.fsf@rustcorp.com.au> <1395211832.8649.40.camel@joe-AO722> <87k3bpr28n.fsf@rustcorp.com.au> <20140320042700.GA11505@redhat.com> <87ob10vnp9.fsf@free.fr> <loom.20140618T155046-940@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 111.93.164.254 (Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/31.0.1650.63 Safari/537.36)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gobinda Charan Maji <gobinda.cemk07 <at> gmail.com> writes:



> 
> Hi All,
> 
> As per the newly added restriction (User perms >= group perms >= other 
> perms) is concerned, there is an inconsistency in the permission. Say for 
> example, permission value is "0432". Here User has only READ permission 
> whereas Group has both WRITE and EXECUTE permission and Other has WRITE 
> permission. I think it is not good to give Group and Other at least WRITE 
> permission whereas User itself has no WRITE permission.
> 
> May be, it's better to check those three permissions bit wise rather than 
as 
> a whole. Please rethink about my point and let me know your opinion.
> 
> Thanks,
> Gobinda
> 
> 

Hi All,

I could not get any response yet.

Hi Rusty,

Please at least give me a reply even if my concept seems to be incorrect to 
you.

Thanks in advance,
Gobinda




