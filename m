Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752356AbaCGLmT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 06:42:19 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:18245 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969AbaCGLmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 06:42:18 -0500
Message-ID: <5319B094.7060709@oracle.com>
Date: Fri, 07 Mar 2014 12:42:12 +0100
From: Vegard Nossum <vegard.nossum@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] isdnloop: NUL-terminate strings from userspace
References: <1394189764-21754-1-git-send-email-vegard.nossum@oracle.com> <20140307112655.GJ4774@mwanda>
In-Reply-To: <20140307112655.GJ4774@mwanda>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/2014 12:26 PM, Dan Carpenter wrote:
> On Fri, Mar 07, 2014 at 11:56:04AM +0100, Vegard Nossum wrote:
>> Both the in-kernel and BSD strlcpy() require that the source string is
>> NUL terminated.
>
> No.  You're obviously wrong.  What on earth?

Well, from lib/string.c:

size_t strlcpy(char *dest, const char *src, size_t size)
{
         size_t ret = strlen(src);

The BSD man page:

"Also note that strlcpy() and strlcat() only operate on true ``C'' 
strings.  This means that for strlcpy() src must be NUL-terminated and 
for strlcat() both src and dst must be NUL-terminated."


Vegard
