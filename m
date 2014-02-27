Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754322AbaB0AwR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 19:52:17 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47814 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752868AbaB0AwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 19:52:16 -0500
Message-ID: <530E8C2E.7080307@zytor.com>
Date: Wed, 26 Feb 2014 16:51:58 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: The sheer number of sparse warnings in the kernel
References: <530E6F76.1070605@zytor.com> <1393462087.24588.50.camel@joe-AO722>
In-Reply-To: <1393462087.24588.50.camel@joe-AO722>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26/2014 04:48 PM, Joe Perches wrote:
> err.h could also return bool instead of long for the
> IS_ERR and IS_ERR_OR_NULL tests.

This is definitely true... although we should check that that doesn't
make the code worse as this is used *all over* the kernel.

> Maybe something like this could be useful.
> 
> Shut up the unsigned<->signed pointer conversions
> and implicit conversions in the Makefile.

Sounds like two separate patches to me.

	-hpa


