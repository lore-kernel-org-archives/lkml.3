Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755135Ab3L1EC5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 23:02:57 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:51415 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755102Ab3L1ECz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 23:02:55 -0500
Message-ID: <1388203372.5387.85.camel@marge.simpson.net>
Subject: Re: TSC Problems (warp between CPUs)
From: Mike Galbraith <bitbucket@online.de>
To: Alex <xor@xor.bz>
Cc: linux-kernel@vger.kernel.org
Date: Sat, 28 Dec 2013 05:02:52 +0100
In-Reply-To: <b65bbca027bb2a473f989e60871c2dd2@xor.bz>
References: <b65bbca027bb2a473f989e60871c2dd2@xor.bz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:nn2X+oxKAK/rYzUsj7OcXCKF6F9gdyxCpqwXYMACrp3
 R6Hb+R9Gzcij7GdphDz1WOTw1wLfiPqLBtpQUyEP3INFl3xpDe
 tt/scrA/7jJAmj60VE87F0EkJ2o95VANOEpTubit4j+hkYKybk
 UzmsDN6cHZi75i1lHOaRyxxP1M9EpT1OYYOEOnKh4PDfqWNZWm
 aeSLJuslCnVOgLWNVLEvFaSjRJKtxvsTiBpzIRYCYMuSC6KTGS
 2RNM7+zkZWoQ8K2nfpsnW70ErkxCntvPhYl9GS8D9DCuzvnw8u
 Y03od5IPTAneox6WWFG3S2jYOAPM3GsC1crMZpU25L7pemPDaM
 xEQ5bG5VyOw2Oa0hn0L8/cSrMCfe6A06JMwZAw0k39+TwS3hAA
 0Ccnjoiub9adA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-12-28 at 13:24 +1100, Alex wrote:

> Linux does not write to the TSC since quite a while... which means the 
> BIOS is doing that. It really should not.

I saw the same on an Intel server recently, poor thing was stuck with
using HPET.

-Mike

