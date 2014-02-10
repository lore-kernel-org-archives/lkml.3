Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752087AbaBJEiX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 23:38:23 -0500
Received: from us01smtprelay-2.synopsys.com ([198.182.60.111]:42153 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556AbaBJEiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 23:38:22 -0500
Message-ID: <52F85707.9000901@synopsys.com>
Date: Mon, 10 Feb 2014 10:05:19 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>, Richard Weinberger <richard@nod.at>
CC: open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 27/28] Remove ARC_HAS_COH_RTSC
References: <1391971686-9517-1-git-send-email-richard@nod.at>	 <1391971686-9517-28-git-send-email-richard@nod.at> <1391975219.25855.8.camel@x220>
In-Reply-To: <1391975219.25855.8.camel@x220>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.80]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On Monday 10 February 2014 01:16 AM, Paul Bolle wrote:
>> The symbol is an orphan, get rid of it.
>> > 
>> > Signed-off-by: Richard Weinberger <richard@nod.at>
> Acked-by: Paul Bolle <pebolle@tiscali.nl>
> 
> This Kconfig symbol was removed in commit 7d087a54aed ("ARC: [SMP]
> Disallow RTSC"), merged in v3.13.
> 

I've applied you ACK, with the fixed commit-id 7d0857a54aed

Thx,
-Vineet
