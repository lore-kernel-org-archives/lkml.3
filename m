Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964940AbaD2SGu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 14:06:50 -0400
Received: from shelob.surriel.com ([74.92.59.67]:48120 "EHLO
	shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757530AbaD2SGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 14:06:48 -0400
From: riel@redhat.com
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, paulmck@linux.vnet.ibm.com,
        rdunlap@infradead.org, richard@nod.at, umgwanakikbuti@gmail.com
Subject: [PATCH 0/2] fixed sysrq & rcu patches
Date: Tue, 29 Apr 2014 14:06:34 -0400
Message-Id: <1398794796-17464-1-git-send-email-riel@redhat.com>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew, these patches contain all the fixes from the threads. They
seem to compile on normal x86 and UML now.

Thanks to Paul, Randy, and everybody else.

