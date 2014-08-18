Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751841AbaHRFfh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 01:35:37 -0400
Received: from senator.holtmann.net ([87.106.208.187]:33674 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264AbaHRFfg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 01:35:36 -0400
From: Marcel Holtmann <marcel@holtmann.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: Issue with clone() and CLONE_NEWUSER as unprivileged user
Message-Id: <606D4327-C729-49F7-9CFD-3D25D0A62A13@holtmann.org>
Date: Mon, 18 Aug 2014 00:35:31 -0500
To: LKML <linux-kernel@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am trying to use clone() and CLONE_NEWUSER for creating a new user namespace as an unprivileged user. I always get an operation not permitted error. However when I used fork() + unshare() as unprivileged user, I can create the new user namespace just fine.

Is there something obvious that I am missing? My understand is that CLONE_NEWUSER should not require any special capabilities. I tried the sample code from the manpage and also from LWN.net, but both give me the same error.

Regards

Marcel

