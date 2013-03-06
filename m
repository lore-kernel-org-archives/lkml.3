Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755203Ab3CFNCO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 08:02:14 -0500
Received: from mail.not-your-server.de ([78.46.182.243]:46094 "EHLO
	mail.not-your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752816Ab3CFNCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 08:02:07 -0500
From: jlec@gentoo.org
To: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Final versions of ncurses libs detection patches
Date: Wed,  6 Mar 2013 14:02:00 +0100
Message-Id: <1362574922-4799-1-git-send-email-jlec@gentoo.org>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <Use config scripts to detect ncurses libs for, menuconfig/nconfig dialogs>
References: <Use config scripts to detect ncurses libs for, menuconfig/nconfig dialogs>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello,

I am sorry for the long delay.
Final versions of the patches which are reduced to the usage of pkg-config. And
if unavailable we use the old code.

Thanks for all suggestions,
Justin
