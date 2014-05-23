Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786AbaEWJH6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 05:07:58 -0400
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:50892 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751092AbaEWJH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 05:07:56 -0400
Message-ID: <1400836074.31526.14.camel@x220>
Subject: Re: [PATCH] [RESEND] ARM: remove last use of CONFIG_CPU_ARM710
From: Paul Bolle <pebolle@tiscali.nl>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Date: Fri, 23 May 2014 11:07:54 +0200
In-Reply-To: <4305975.PvMXZQ020k@wuerfel>
References: <1364507176.1345.45.camel@x61.thuisdomein>
	 <8309592.drxAj71PnZ@wuerfel> <1400059550.31197.12.camel@x220>
	 <4305975.PvMXZQ020k@wuerfel>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 May 2014 09:07:55.0338 (UTC) FILETIME=[7BD5BAA0:01CF7666]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-05-14 at 11:28 +0200, Arnd Bergmann wrote:
> On Wednesday 14 May 2014 11:25:50 Paul Bolle wrote:
> > On Wed, 2014-05-14 at 11:17 +0200, Arnd Bergmann wrote:
> > > 'git grep -i arm710' tells me that there is also some arm710
> > > specific code in  arch/arm/mm/proc-arm720.S that we may want to
> > > remove along with this.
> > > 
> > > The DT binding should probably remain untouched though, I think it's
> > > correct to document the string.
> > 
> > That seems to be cpu_arm710_name, __arm710_setup, and everything called
> > by __arm710_setup. Cleaning that up (as a separate patch) appears to be
> > trivial. If I do that it would be (sort of educated) guesswork. But I
> > don't mind doing it. What do you prefer?
> 
> I think that would be great. For the first patch, please add 
> 
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> 
> Once the second patch is reviewed, please add them both to Russell's
> patch tracker.

Well, at least that second patch triggered a nice conversation. So I
should now add the first patch (with your ACK) to the tracker?


Paul Bolle

