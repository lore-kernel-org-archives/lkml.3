Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758072Ab3LGE5P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 23:57:15 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36565 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756727Ab3LGE5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 23:57:14 -0500
Message-ID: <52A2AAA4.7010306@infradead.org>
Date: Fri, 06 Dec 2013 20:57:08 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>, Stefan Weil <sw@weilnetz.de>,
        linux-kernel@vger.kernel.org
CC: Jiri Kosina <trivial@kernel.org>, linux-rpi-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: bcm2835: Fix grammar in help message
References: <1386271060-2375-1-git-send-email-sw@weilnetz.de> <52A2A6EB.8040207@wwwdotorg.org>
In-Reply-To: <52A2A6EB.8040207@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/13 20:41, Stephen Warren wrote:
> On 12/05/2013 12:17 PM, Stefan Weil wrote:
>> Replace "is use" by "is used" and remove a comma.
> 
> Applied to bcm2835's for-3.14/soc branch.
> 
> (I'm not convinced about the
> serial-comma-applies-to-lists-of-three-or-more-items rule, since two
> items are clearly a list, and it's inconsistent with what I recall
> seeing in practice, but anyway).

I agree with Arnd's comments -- serial comma is not for use just to
separate <a> and <b>.


-- 
~Randy
