Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661Ab3LGElW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 23:41:22 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:59196 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754171Ab3LGElT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 23:41:19 -0500
Message-ID: <52A2A6EB.8040207@wwwdotorg.org>
Date: Fri, 06 Dec 2013 21:41:15 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Stefan Weil <sw@weilnetz.de>, linux-kernel@vger.kernel.org
CC: Jiri Kosina <trivial@kernel.org>, linux-rpi-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: bcm2835: Fix grammar in help message
References: <1386271060-2375-1-git-send-email-sw@weilnetz.de>
In-Reply-To: <1386271060-2375-1-git-send-email-sw@weilnetz.de>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2013 12:17 PM, Stefan Weil wrote:
> Replace "is use" by "is used" and remove a comma.

Applied to bcm2835's for-3.14/soc branch.

(I'm not convinced about the
serial-comma-applies-to-lists-of-three-or-more-items rule, since two
items are clearly a list, and it's inconsistent with what I recall
seeing in practice, but anyway).
