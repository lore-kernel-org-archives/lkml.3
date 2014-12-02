Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932555AbaLBQUp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 11:20:45 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:51695 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523AbaLBQUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 11:20:44 -0500
Message-ID: <547DE6D8.8090209@codeaurora.org>
Date: Tue, 02 Dec 2014 11:20:40 -0500
From: Christopher Covington <cov@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Michael Ellerman <mpe@ellerman.id.au>
CC: linux-kernel@vger.kernel.org, shuahkh@osg.samsung.com,
        Andrew Morton <akpm@osdl.org>, gorcunov@openvz.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 3/3] selftests/kcmp: Always try to build the test
References: <1417499528-23377-1-git-send-email-mpe@ellerman.id.au> <1417499528-23377-3-git-send-email-mpe@ellerman.id.au>
In-Reply-To: <1417499528-23377-3-git-send-email-mpe@ellerman.id.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

On 12/02/2014 12:52 AM, Michael Ellerman wrote:
> Don't prevent the test building on non-x86. Just try and build it and
> let the chips fall where they may.
> 
> Add support for CROSS_COMPILE while we're at it. Also we don't need a
> custom rule for building kcmp_test.
> 
> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>

For what it's worth, all three patches look good to me.

Reviewed-by: Christopher Covington <cov@codeaurora.org>

Thanks,
Chris

-- 
Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
