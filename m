Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000Ab3LLMmX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 07:42:23 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:44328 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788Ab3LLMmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 07:42:19 -0500
Message-ID: <52A9AF2D.80100@cogentembedded.com>
Date: Thu, 12 Dec 2013 16:42:21 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: phdm@macqel.be, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        frank.li@freescale.net
Subject: Re: [PATCH] net:fec: remove duplicate lines in comment about errata
 ERR006358
References: <1386802252-5817-1-git-send-email-phdm@macqel.be>
In-Reply-To: <1386802252-5817-1-git-send-email-phdm@macqel.be>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 12-12-2013 2:50, phdm@macqel.be wrote:

> From: Philippe De Muyter <phdm@macqel.be>

> commit 031916568a1aa2ef1809f86d26f0bcfa215ff5c0 worked around

    Please also specify that commit's summary line in parens.

> errata ERR006358, but comment contains duplicated lines, impairing
> the readability.  Remove them.

> Signed-off-by: Philippe De Muyter <phdm@macqel.be>

WBR, Sergei


