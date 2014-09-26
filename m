Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759AbaIZMPG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 08:15:06 -0400
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:49319 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753986AbaIZMPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 08:15:04 -0400
Message-ID: <1411733700.7866.29.camel@x220>
Subject: ARM: meson: MESON6_TIMER?
From: Paul Bolle <pebolle@tiscali.nl>
To: Carlo Caione <carlo@caione.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Fri, 26 Sep 2014 14:15:00 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-3.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Sep 2014 12:15:01.0211 (UTC) FILETIME=[7F0682B0:01CFD983]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Carlo,

Your commit 3b8f5030ddcf ("ARM: meson: add basic support for MesonX
SoCs") landed in next-20140926. It adds (among other things) a select
statement:
    select MESON6_TIMER

But there's no Kconfig symbol MESON6_TIMER (in next-20140926). I assume
that this symbol is queued somewhere. (Probably related is the currently
orphaned DT string "amlogic,meson6-timer".) Is that correct?


Paul Bolle

