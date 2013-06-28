Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518Ab3F1Njy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 09:39:54 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39856 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981Ab3F1Njx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 09:39:53 -0400
Message-ID: <51CD9225.3070801@ubuntu.com>
Date: Fri, 28 Jun 2013 14:39:49 +0100
From: James Hunt <james.hunt@ubuntu.com>
Reply-To: james.hunt@ubuntu.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: "upstart-devel >> \"upstart-devel >> Upstart Devel List\"" 
	<upstart-devel@lists.ubuntu.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Upstart 1.9 released
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Summary of changes:

* Apparmor support added by means of two new stanzas: 'apparmor load'
  and 'apparmor switch' (thanks Marc Deslauriers).
* Stateful re-exec: now serialises all objects, not just the minimum set.
* Allow inherited environment variables to be unset for Session Inits.
* Ability to specify multiple configuration directories when running as
  a Session Init.
* libupstart: Client library for communicating with Upstart.
* upstart-dbus-bridge: New bridge to allow jobs to react to D-Bus signals.
* The usual round of fixes and doc improvements.

Thanks to all involved!

Download Upstart 1.9 from launchpad: https://launchpad.net/upstart

Kind regards,

James.
--
James Hunt
____________________________________
#upstart on freenode
http://upstart.ubuntu.com/cookbook
https://lists.ubuntu.com/mailman/listinfo/upstart-devel
