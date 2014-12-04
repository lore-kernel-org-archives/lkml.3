Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932966AbaLDTo2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 14:44:28 -0500
Received: from message.langara.bc.ca ([209.87.29.115]:37050 "EHLO
	message.langara.bc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822AbaLDTo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 14:44:27 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-disposition: inline
Content-type: text/plain; charset=us-ascii
From: Steven Stewart-Gallus <sstewartgallus00@mylangara.bc.ca>
To: linux-kernel@vger.kernel.org
Message-id: <fc15da367389.5480b999@langara.bc.ca>
Date: Thu, 04 Dec 2014 19:44:25 +0000 (GMT)
X-Mailer: Sun Java(tm) System Messenger Express 6.3-6.03 (built Mar 14 2008;
 32bit)
Content-language: en
Subject: How can I parse the command name from /proc/<pid>/stat?
X-Accept-Language: en
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Given an evil hacker trying to confuse process monitors that might use such
strange process names as 'pause) R 0 0 (foo' how can I correctly parse the
command name from /proc/<pid>/stat? Maybe I should just use /proc/<pid>/status?
Maybe there should be some documentation written on the issue? I just wanted to
send an email off to check if I was missing anything before writing a few small
additions to the documentation or filing a bug report. procps-ng seems to use an
ugly hack that involves knowing the limits on the size of a possible command
name that I'm not actually sure works totally correctly.

Thank you,
Steven Stewart-Gallus
