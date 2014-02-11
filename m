Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756429AbaBKVKu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 16:10:50 -0500
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:58834 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756404AbaBKVKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 16:10:48 -0500
Message-ID: <1392153045.14317.5.camel@x220>
Subject: Re: What commit dropped config PLAT_SPEAR_SINGLE?
From: Paul Bolle <pebolle@tiscali.nl>
To: Ortwin =?ISO-8859-1?Q?Gl=FCck?= <odi@odi.ch>
Cc: linux-kernel@vger.kernel.org
Date: Tue, 11 Feb 2014 22:10:45 +0100
In-Reply-To: <52FA8E87.7080705@odi.ch>
References: <52FA8E87.7080705@odi.ch>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 11 Feb 2014 21:10:46.0057 (UTC) FILETIME=[BB138190:01CF276D]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-02-11 at 21:56 +0100, Ortwin Glück wrote:
> The next commit on that file:
> 3a768d04639307db  Merge branch 'spear/multiplatform' into next/multiplatform

Thanks!

> easy to see with this:
> gitk v3.13 arch/arm/Kconfig

And now I've found that, for instance, the "-c" option of "git log"
would have showed me too.


Paul Bolle

