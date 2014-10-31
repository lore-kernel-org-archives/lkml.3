Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756551AbaJaIkk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 04:40:40 -0400
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:51113 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750912AbaJaIki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 04:40:38 -0400
Message-ID: <1414744834.1964.7.camel@x220>
Subject: iwlwifi: mvm:  BACKPORT_WANT_DEV_COREDUMP?
From: Paul Bolle <pebolle@tiscali.nl>
To: Johannes Berg <johannes.berg@intel.com>
Cc: Valentin Rothberg <valentinrothberg@gmail.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Intel Linux Wireless <ilw@linux.intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 31 Oct 2014 09:40:34 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 31 Oct 2014 08:40:35.0564 (UTC) FILETIME=[56F5D2C0:01CFF4E6]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Your commit aadede6e9f4c ("iwlwifi: mvm: port to devcoredump framework")
landed in today's linux-next (next-20141031). It adds a select statement
for BACKPORT_WANT_DEV_COREDUMP. There's no Kconfig symbol 
BACKPORT_WANT_DEV_COREDUMP so this select is currently a nop. (In
https://lkml.org/lkml/2014/9/30/578 I proposed a patch that emits a
warning in cases like this.)

Did you perhaps meant to select WANT_DEV_COREDUMP? Or is the Kconfig
symbol BACKPORT_WANT_DEV_COREDUMP queued somewhere?


Paul Bolle

