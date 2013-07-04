Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756800Ab3GDPbb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 11:31:31 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51176 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756590Ab3GDPba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 11:31:30 -0400
Message-ID: <51D59550.7080207@ubuntu.com>
Date: Thu, 04 Jul 2013 16:31:28 +0100
From: James Hunt <james.hunt@ubuntu.com>
Reply-To: james.hunt@ubuntu.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: "upstart-deve >> \"upstart-devel >> Upstart Devel List\"" 
	<upstart-devel@lists.ubuntu.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Upstart 1.9.1 released
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Summary of changes:

* Fix respawn behaviour regression (introduced in version 1.8) affecting
  jobs which also specify shell meta-characters in the exec stanza
  (LP: #1181789).
* Fix common bug which could cause a bridge to crash (LP: #1197225).
* Various fixes for libupstart.
* initctl2dot: Layout improvements.

Kind regards,

James.
--
James Hunt
____________________________________
#upstart on freenode
http://upstart.ubuntu.com/cookbook
https://lists.ubuntu.com/mailman/listinfo/upstart-devel
