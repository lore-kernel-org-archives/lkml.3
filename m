Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757838AbaAJTZx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 14:25:53 -0500
Received: from forward5m.mail.yandex.net ([37.140.138.5]:33973 "EHLO
	forward5m.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172AbaAJTZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 14:25:50 -0500
From: Victor Porton <porton@narod.ru>
Envelope-From: porton@yandex.ru
To: selinux@tycho.nsa.gov, linux-kernel@vger.kernel.org
Subject: Create new NetFilter table
MIME-Version: 1.0
Message-Id: <1171389381947@web15m.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Fri, 10 Jan 2014 21:25:47 +0200
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I propose to create a new NetFilter table dedicated to rules created programmatically (not by explicit admin's iptables command).

Otherwise an admin could be tempted to say `iptables -F security` which would probably break rules created for example by sandboxing software (which may follow same-origin policy to restrict one particular program to certain domain and port only). Note that in this case `iptables -F security` is a security risk (sandbox breaking)?

New table could be possibly be called:

- temp
- temporary
- auto
- automatic
- volatile
- daemon
- system
- sys

In iptables docs it should be said that this table should not be manipulated manually.

-- 
Victor Porton - http://portonvictor.org
