Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229AbaDFJhf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 05:37:35 -0400
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:63165 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753510AbaDFJhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 05:37:31 -0400
Message-ID: <1396777049.30640.9.camel@x220>
Subject: Kconfig ARM_ERRATA_753970?
From: Paul Bolle <pebolle@tiscali.nl>
To: Jason Cooper <jason@lakedaemon.net>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        arm@kernel.org, linux-arm-kernel@lists.infradead.org
Date: Sun, 06 Apr 2014 11:37:29 +0200
In-Reply-To: <201404052104.11363.arnd@arndb.de>
References: <201404052101.19381.arnd@arndb.de>
	 <201404052104.11363.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Apr 2014 09:37:30.0617 (UTC) FILETIME=[D4918E90:01CF517B]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-04-05 at 20:04 +0100, Arnd Bergmann wrote:
> Gregory CLEMENT (1):
>       ARM: mvebu: add initial support for the Armada 375 SOCs
> 
>[...]
>
> Thomas Petazzoni (7):
>       [...]
>       ARM: mvebu: add initial support for the Armada 380/385 SOCs

These two commits added select statements for ARM_ERRATA_753970. But I
couldn't find that Kconfig symbol. (I checked master of Linus' tree and
current linux-next.) So it seems it was intended to select
PL310_ERRATA_753970 here. Is that correct?


Paul Bolle

