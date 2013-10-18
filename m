Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752574Ab3JRJCl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 05:02:41 -0400
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:65431 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752009Ab3JRJCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 05:02:39 -0400
Message-ID: <1382086956.16689.6.camel@x220.thuisdomein>
Subject: module: Documentation/module-signing.txt?
From: Paul Bolle <pebolle@tiscali.nl>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org
Date: Fri, 18 Oct 2013 11:02:36 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Oct 2013 09:02:36.0885 (UTC) FILETIME=[CA61E850:01CECBE0]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty,

Since v3.7 there's a link to Documentation/module-signing.txt in
init/Kconfig. It was added by your commit 106a4ee258d1 ("module:
signature checking hook"). It seems that this file was never added to
the tree. Is it perhaps queued somewhere?


Paul Bolle

