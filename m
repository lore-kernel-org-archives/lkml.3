Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946542Ab3BHMnJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 07:43:09 -0500
Received: from chrocht.moloch.sk ([62.176.169.44]:48118 "EHLO mail.moloch.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946412Ab3BHMnI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 07:43:08 -0500
Message-ID: <5114F2D8.5020300@250bpm.com>
Date: Fri, 08 Feb 2013 13:43:04 +0100
From: Martin Sustrik <sustrik@250bpm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111109 Thunderbird/3.1.16
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Alexander Viro <viro@zeniv.linux.org.uk>,
        Sha Zhengju <handai.szj@taobao.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/1] eventfd: implementation of EFD_MASK flag
References: <1360219292-19754-1-git-send-email-sustrik@250bpm.com> <20130207144433.527ef024.akpm@linux-foundation.org>
In-Reply-To: <20130207144433.527ef024.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/13 23:44, Andrew Morton wrote:

> That's a nice changelog but it omitted a critical thing: why do you
> think the kernel needs this feature?  What's the value and use case for
> being able to poll these descriptors?

To address the question, I've written down detailed description of the 
challenges of the network protocol development in user space and how the 
proposed feature addresses the problems.

It's too long to fit into ChangeLog, but it may be worth reading when 
trying to judge the merit of the patch.

It can be found here: http://www.250bpm.com/blog:16

Martin
