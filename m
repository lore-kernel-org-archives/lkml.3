Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983AbaJUQKG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 12:10:06 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:41513 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755666AbaJUQKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 12:10:04 -0400
Message-ID: <54468558.8040204@cogentembedded.com>
Date: Tue, 21 Oct 2014 20:10:00 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>, Sekhar Nori <nsekhar@ti.com>,
        Russell King <linux@arm.linux.org.uk>
CC: davinci-linux-open-source@linux.davincidsp.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: davinci: Remove redundant casts
References: <1413903211-3143-1-git-send-email-linux@rasmusvillemoes.dk>
In-Reply-To: <1413903211-3143-1-git-send-email-linux@rasmusvillemoes.dk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 10/21/2014 06:53 PM, Rasmus Villemoes wrote:

> These casts to char* are unnecessary and slightly confusing, since
> both operands actually have type const char*.

    Both operands of what? Typecast only has 1 operand. :-)

> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>

WBR, Sergei


