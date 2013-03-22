Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932937Ab3CVIKt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 04:10:49 -0400
Received: from smtprelay05.ispgateway.de ([80.67.31.99]:44360 "EHLO
	smtprelay05.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753657Ab3CVIKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 04:10:40 -0400
Message-ID: <514C11FB.8090507@ladisch.de>
Date: Fri, 22 Mar 2013 09:10:35 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Eduardo Cruz <eduardohmdacruz@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: remap kernel static memory to user space
References: <CAHG_u-=ChwiQ72O-9z1eD5Pex-niYMaRwMUOQOryYuPO154G=A@mail.gmail.com> <CAHG_u-=O0+2SLYQL_GtP9Yk72EcZjHaxLgu=rwB2DAPsTaXnvA@mail.gmail.com>
In-Reply-To: <CAHG_u-=O0+2SLYQL_GtP9Yk72EcZjHaxLgu=rwB2DAPsTaXnvA@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: bGludXgta2VybmVsQGNsLmRvbWFpbmZhY3Rvcnkta3VuZGUuZGU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eduardo Cruz wrote:
> Please, anyone knows how to solve this problem?
>
> 2013/3/20 Eduardo Cruz <eduardohmdacruz@gmail.com>:
>> I'm trying to remap some kernel static memory to user space using
>> remap_pfn_range.

Well, don't do that.

What is the actual problem you're trying to solve?


Regards,
Clemens
