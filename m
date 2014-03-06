Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757596AbaCFApU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 19:45:20 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:34137 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755012AbaCFApS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 19:45:18 -0500
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: linux-doc@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Runzhen Wang <runzhen@linux.vnet.ibm.com>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Linux PPC <linuxppc-dev@lists.ozlabs.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, rob@landley.net
Subject: [PATCH 0/2] perf: add documentation for sysfs interfaces
Date: Wed,  5 Mar 2014 16:44:13 -0800
Message-Id: <1394066658-16766-1-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.9.0
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14030600-7182-0000-0000-000009FBA316
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Documents <pmu>/event/<event>{,.scale,.units} and then removes the redundant
POWER docs.

Slightly restricts <event> names to avoid API funkyness when we add new
<event>.????? files ('.' forbidden in event names).

The contact is currently lkml, it would be very useful to have a perf
development list to put here instead (acme, feel like making one?).

--

Cody P Schafer (2):
  perf Documentation: sysfs events/ interfaces
  perf Documentation: remove duplicated docs for powerpc cpu specific
    events

 .../testing/sysfs-bus-event_source-devices-events  | 92 +++++++++++-----------
 1 file changed, 47 insertions(+), 45 deletions(-)

-- 
1.9.0

