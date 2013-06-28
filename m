Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771Ab3F1FbL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 01:31:11 -0400
Received: from merlin.infradead.org ([205.233.59.134]:42935 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814Ab3F1FbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 01:31:09 -0400
Message-ID: <51CD1F81.4040202@infradead.org>
Date: Thu, 27 Jun 2013 22:30:41 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-next@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>
Subject: Re: mmotm 2013-06-27-16-36 uploaded (wait event common)
References: <20130627233733.BAEB131C3BE@corp2gmr1-1.hot.corp.google.com>
In-Reply-To: <20130627233733.BAEB131C3BE@corp2gmr1-1.hot.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27/13 16:37, akpm@linux-foundation.org wrote:
> The mm-of-the-moment snapshot 2013-06-27-16-36 has been uploaded to
> 
>    http://www.ozlabs.org/~akpm/mmotm/
> 
> mmotm-readme.txt says
> 
> README for mm-of-the-moment:
> 
> http://www.ozlabs.org/~akpm/mmotm/
> 

My builds are littered with hundreds of warnings like this one:

drivers/tty/tty_ioctl.c:220:6: warning: the omitted middle operand in ?: will always be 'true', suggest explicit middle operand [-Wparentheses]

I guess due to this line from wait_event_common():

+		__ret = __wait_no_timeout(tout) ?: (tout) ?: 1;



-- 
~Randy
