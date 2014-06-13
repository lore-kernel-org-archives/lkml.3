Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752013AbaFMBt4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 21:49:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42079 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751171AbaFMBtz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 21:49:55 -0400
Message-ID: <539A58AD.4030404@zytor.com>
Date: Thu, 12 Jun 2014 18:49:33 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>, Kui Zhang <kuizhang@gmail.com>
CC: x86@kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 4/4] x86,vdso: Hack to keep 64-bit Go programs working
References: <cover.1402620737.git.luto@amacapital.net> <d10618176c4bd39b457a5e85c497295c90cab1bc.1402620737.git.luto@amacapital.net>
In-Reply-To: <d10618176c4bd39b457a5e85c497295c90cab1bc.1402620737.git.luto@amacapital.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2014 05:53 PM, Andy Lutomirski wrote:
> 
> This is currently broken for big-endian build hosts.  The hack
> should also be disabled for x32, but I'm not sure what the right way
> to do that is.
> 

This comment is obsolete, no?

	-hpa


