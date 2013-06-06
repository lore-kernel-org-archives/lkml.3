Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755642Ab3FFHXw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 03:23:52 -0400
Received: from rrzmta2.uni-regensburg.de ([194.94.155.52]:39392 "EHLO
	rrzmta2.uni-regensburg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754448Ab3FFHXt convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:2:1>);
	Thu, 6 Jun 2013 03:23:49 -0400
Message-Id: <51B05520020000A100011361@gwsmtp1.uni-regensburg.de>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Thu, 06 Jun 2013 09:23:44 +0200
From: "Ulrich Windl" <Ulrich.Windl@rz.uni-regensburg.de>
To: <linux-kernel@vger.kernel.org>
Cc: <jkosina@suse.cz>
Subject: "floppy0: floppy timeout called",
 https://bugzilla.novell.com/show_bug.cgi?id=799559
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

maybe someone wants to have a look at kernel messages that look like debug dumps from the floppy driver. These messages fill up syslog unnecessarily. You can find the kernel messages in https://bugzilla.novell.com/show_bug.cgi?id=799559. Last seen in kernel-default-3.7.10-1.11.1.i586 of openSUSE 12.3...

Regards,
Ulrich


