Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752988Ab3BUJwb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 04:52:31 -0500
Received: from ud10.udmedia.de ([194.117.254.50]:39646 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791Ab3BUJw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 04:52:27 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Feb 2013 04:52:27 EST
Date: Thu, 21 Feb 2013 10:45:44 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [perf bugreport] perf doesn't delete /tmp/perf-vdso.so.* file on exit
Message-ID: <20130221094544.GA2919@x4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Perf doesn't properly clean up /tmp/perf-vdso.so-XXXXXX on exit. So
these files keep accumulating in /tmp every time perf is run.

-- 
Markus
