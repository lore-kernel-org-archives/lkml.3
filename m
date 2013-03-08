Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756917Ab3CHUCe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 15:02:34 -0500
Received: from plane.gmane.org ([80.91.229.3]:49223 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756391Ab3CHUCc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 15:02:32 -0500
X-Injected-Via-Gmane: http://gmane.org/
Mail-Followup-To: linux-kernel@vger.kernel.org
To: linux-kernel@vger.kernel.org
From: rh <richard_hubbe11@lavabit.com>
Subject: IPC Namespace Depends and SYSVIPC
Date: Fri, 8 Mar 2013 12:03:08 -0800
Organization: " "
Message-ID: <20130308120308.4f1ad93c4aed631185494201@lavabit.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: ip68-227-87-145.sb.sd.cox.net
User-Agent: dsodnetnin
X-Mailer: EZnn0.37p
X-Newsreader: EZnn0.37p
X-Gmane-NNTP-Posting-Host: EZnn0.37p
Original-Received: from slem by 1.1 with local
X-No-Archive: yes
Archive: no
X-Archive: expiry=11
X-Archive: encrypt
X-Operating-System: Barebones_6.1
X-Gmane-NNTP-Posting-Host: 192.168.1.1
X-NNTP-Posting-Host: 192.168.1.1
Mail-Copies-To: never
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not sure what I'm looking at but here's what I see when I do a sym
search in nconfig.  Note: Namespace seems to depend in SYSVIPC or
not.

______________________
With SYSVIPC enabled:

Symbol: IPC_NS [=y]
Type  : boolean
Prompt: IPC namespace
Defined at init/Kconfig:794
Depends on: NAMESPACES [=y] && (SYSVIPC [=y] || POSIX_MQUEUE [=y])
Location:
-> General setup
-> Namespaces support (NAMESPACES [=y])

_______________________
With SYSVIPC disabled:


Symbol: IPC_NS [=y]
Type  : boolean
Prompt: IPC namespace
Defined at init/Kconfig:794
Depends on: NAMESPACES [=y] && (SYSVIPC [=n] || POSIX_MQUEUE [=y])
Location:
-> General setup
-> Namespaces support (NAMESPACES [=y])

