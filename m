Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966205AbaLMIsu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2014 03:48:50 -0500
Received: from ud10.udmedia.de ([194.117.254.50]:46279 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966184AbaLMIst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2014 03:48:49 -0500
Date: Sat, 13 Dec 2014 09:48:45 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: "perf top -g" leaking ~300MB per second.
Message-ID: <20141213084845.GA13453@x4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Running "perf top -g" built from current Linus tree apparently leaks
~300MB of memory every second an my machine.

-- 
Markus
