Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816Ab3GAHPW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 03:15:22 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:62869 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506Ab3GAHPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 03:15:21 -0400
From: stefan.seyfried@googlemail.com
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org
Subject: 8250_pci: improve code comments and Kconfig help
Date: Mon,  1 Jul 2013 09:14:20 +0200
Message-Id: <1372662861-11231-1-git-send-email-stefan.seyfried@googlemail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20130630160226.GA26644@kroah.com>
References: <20130630160226.GA26644@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

in order to avoid such regressions in the future, a comment in
the source and a note in the Kconfig help text might be useful

This patch is against
git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git tty-next

Best regards,

	Stefan

-- 
Stefan Seyfried
Linux Consultant & Developer -- GPG Key: 0x731B665B

B1 Systems GmbH
Osterfeldstraße 7 / 85088 Vohburg / http://www.b1-systems.de
GF: Ralph Dehner / Unternehmenssitz: Vohburg / AG: Ingolstadt,HRB 3537
