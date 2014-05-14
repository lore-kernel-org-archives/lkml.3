Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147AbaENJZz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 05:25:55 -0400
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:52576 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753312AbaENJZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 05:25:52 -0400
Message-ID: <1400059550.31197.12.camel@x220>
Subject: Re: [PATCH] [RESEND] ARM: remove last use of CONFIG_CPU_ARM710
From: Paul Bolle <pebolle@tiscali.nl>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Date: Wed, 14 May 2014 11:25:50 +0200
In-Reply-To: <8309592.drxAj71PnZ@wuerfel>
References: <1364507176.1345.45.camel@x61.thuisdomein>
	 <1400055865.31197.4.camel@x220> <8309592.drxAj71PnZ@wuerfel>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 May 2014 09:25:50.0696 (UTC) FILETIME=[7F149680:01CF6F56]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-05-14 at 11:17 +0200, Arnd Bergmann wrote:
> 'git grep -i arm710' tells me that there is also some arm710
> specific code in  arch/arm/mm/proc-arm720.S that we may want to
> remove along with this.
> 
> The DT binding should probably remain untouched though, I think it's
> correct to document the string.

That seems to be cpu_arm710_name, __arm710_setup, and everything called
by __arm710_setup. Cleaning that up (as a separate patch) appears to be
trivial. If I do that it would be (sort of educated) guesswork. But I
don't mind doing it. What do you prefer?


Paul Bolle

