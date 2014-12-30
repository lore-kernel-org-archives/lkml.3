Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751769AbaL3Pmg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 10:42:36 -0500
Received: from mail-we0-f179.google.com ([74.125.82.179]:41715 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbaL3Pmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 10:42:35 -0500
X-Greylist: delayed 349 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Dec 2014 10:42:34 EST
Date: Tue, 30 Dec 2014 16:36:42 +0100
From: Sylvain BERTRAND <sylvain.bertrand@gmail.com>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] x86: tools: shell-ify calc_run_size perl-ism
Message-ID: <20141230153642.GA19036@dhcppc1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chocked while compiling linux on a lightweight system, i.e. freed from perl.

New script tested with dash shell and bash shell.
