Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753028AbaEBUYO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 16:24:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51617 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752745AbaEBUYK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 16:24:10 -0400
Message-ID: <5363FED4.4050909@zytor.com>
Date: Fri, 02 May 2014 13:23:48 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>, x86@kernel.org
CC: Stefani Seibold <stefani@seibold.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/6] x86: Move syscall and sysenter setup into kernel/cpu/common.c
References: <cover.1399061075.git.luto@amacapital.net> <169f183193e4fafa0892a00969d487b334cd7e76.1399061075.git.luto@amacapital.net>
In-Reply-To: <169f183193e4fafa0892a00969d487b334cd7e76.1399061075.git.luto@amacapital.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/2014 01:15 PM, Andy Lutomirski wrote:
> This just moves code around.
> 
> Signed-off-by: Andy Lutomirski <luto@amacapital.net>

One more thing: please explain *why* here.

	-hpa


