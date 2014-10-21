Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754447AbaJUGqt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 02:46:49 -0400
Received: from rrzmta1.uni-regensburg.de ([194.94.155.51]:40436 "EHLO
	rrzmta1.uni-regensburg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbaJUGqs convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:1:1>);
	Tue, 21 Oct 2014 02:46:48 -0400
Message-Id: <54461D74020000A100017750@gwsmtp1.uni-regensburg.de>
X-Mailer: Novell GroupWise Internet Agent 14.0.1 
Date: Tue, 21 Oct 2014 08:46:44 +0200
From: "Ulrich Windl" <Ulrich.Windl@rz.uni-regensburg.de>
To: <linux-kernel@vger.kernel.org>
Subject: FYI: unclean Intel RAID reported as "clean"
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I detected a problem with an Intel (imsm, ICH) RAID1 reported as "clean" by Linux, while the BIOS and Windows claimed the RAID is in state "rebuild". This was for an older kernel, and the bug had been reported to openSUSE bugzilla as bug #902000. Anyone interested can find the details there. I thought the problem is important enough to let you know...

Regards,
Ulrich


