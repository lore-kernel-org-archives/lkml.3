Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752059Ab3CAPuw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 10:50:52 -0500
Received: from mail.not-your-server.de ([78.46.182.243]:60168 "EHLO
	mail.not-your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478Ab3CAPus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 10:50:48 -0500
From: jlec@gentoo.org
To: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: ncurses detection for nconfig/menuconfig patches revised
Date: Fri,  1 Mar 2013 16:50:42 +0100
Message-Id: <1362153044-23611-1-git-send-email-jlec@gentoo.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <jlec@gentoo.org>
References: <jlec@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello,

After the discussion I modified the patches to respect following things

1. Don't remove the legacy detection
2. use helpers in following order: 
	pkg-config, ncurses5-config, ncurses6-config, old heuristic
3. only support the wide char implementation for menuconfig


Regards,
justin

