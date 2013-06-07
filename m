Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756947Ab3FGTuv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 15:50:51 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:43522 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105Ab3FGTut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 15:50:49 -0400
Message-ID: <51B2398A.7020104@hp.com>
Date: Fri, 07 Jun 2013 15:50:34 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Stephen Smalley <sds@tycho.nsa.gov>
CC: James Morris <james.l.morris@oracle.com>,
        Eric Paris <eparis@parisplace.org>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH v2 1/2] SELinux: reduce overhead of mls_level_isvalid()
 function call
References: <1370466902-21144-1-git-send-email-Waiman.Long@hp.com> <51B221F1.7090504@tycho.nsa.gov>
In-Reply-To: <51B221F1.7090504@tycho.nsa.gov>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2013 02:09 PM, Stephen Smalley wrote:
>
> Can't you unify this logic with the nearly identical logic below?
>

By separating the logic, we can usually get the best performance out of 
the two separate loops. If code size and maintainability are a bigger 
concern, I can certainly merge the logic. I will try to merge and send 
out a new patch if the performance difference is negligible.

Regards,
Longman
