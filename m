Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756173Ab3FEPS3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 11:18:29 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:20130 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755794Ab3FEPS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 11:18:28 -0400
Message-ID: <51AF56B9.5090406@hp.com>
Date: Wed, 05 Jun 2013 11:18:17 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Stephen Smalley <sds@tycho.nsa.gov>
CC: James Morris <james.l.morris@oracle.com>,
        Eric Paris <eparis@parisplace.org>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH RFC 1/2] SELinux: reduce overhead of mls_level_isvalid()
 function call
References: <1365618383-29340-1-git-send-email-Waiman.Long@hp.com> <5183C4BE.5030504@hp.com> <51AF5251.5060104@tycho.nsa.gov>
In-Reply-To: <51AF5251.5060104@tycho.nsa.gov>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2013 10:59 AM, Stephen Smalley wrote:
>
> Can you take the core logic into a helper function within ebitmap.c? 
> Otherwise you are directly exposing ebitmap internals to the mls code.

Sure. I will move the logic to ebitmap.c & send out an updated patch.

Thank for the quick response.

Regards,
Longman
