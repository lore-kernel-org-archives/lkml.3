Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755881AbaBKU4p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 15:56:45 -0500
Received: from fep20.mx.upcmail.net ([62.179.121.40]:47290 "EHLO
	fep20.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819AbaBKU4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 15:56:42 -0500
X-SourceIP: 77.56.27.120
X-Authenticated-Sender: odi.ch@hispeed.ch
Message-ID: <52FA8E87.7080705@odi.ch>
Date: Tue, 11 Feb 2014 21:56:39 +0100
From: =?ISO-8859-1?Q?Ortwin_Gl=FCck?= <odi@odi.ch>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: linux-kernel@vger.kernel.org
Subject: Re: What commit dropped config PLAT_SPEAR_SINGLE?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The next commit on that file:
3a768d04639307db  Merge branch 'spear/multiplatform' into next/multiplatform

easy to see with this:
gitk v3.13 arch/arm/Kconfig

Cheers,

Ortwin
