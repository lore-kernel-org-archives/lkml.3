Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456AbaFLUVT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 16:21:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37179 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751975AbaFLUVS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 16:21:18 -0400
Message-ID: <539A0BB4.1060204@zytor.com>
Date: Thu, 12 Jun 2014 13:21:08 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>, Kui Zhang <kuizhang@gmail.com>
CC: x86@kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] x86,vdso: Hack to keep 64-bit Go programs working
References: <cover.1402598632.git.luto@amacapital.net> <ad9f313026949247ed2067631b4e5c27c1935064.1402598632.git.luto@amacapital.net>
In-Reply-To: <ad9f313026949247ed2067631b4e5c27c1935064.1402598632.git.luto@amacapital.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2014 11:47 AM, Andy Lutomirski wrote:
> 
> This is currently broken for big-endian build hosts.  The hack
> should also be disabled for x32, but I'm not sure what the right way
> to do that is.
> 

Well, if it isn't exported into the x32 vdso it isn't an issue, right?

	-hpa

