Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757638Ab3LBVKw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 16:10:52 -0500
Received: from mail-qe0-f44.google.com ([209.85.128.44]:64992 "EHLO
	mail-qe0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755220Ab3LBVKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 16:10:48 -0500
From: William Roberts <bill.c.roberts@gmail.com>
To: linux-audit@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        rgb@redhat.com, viro@zeniv.linux.org.uk
Cc: sds@tycho.nsa.gov
Subject: [PATCH] - auditing cmdline
Date: Mon,  2 Dec 2013 13:10:36 -0800
Message-Id: <1386018639-18916-1-git-send-email-wroberts@tresys.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series relates to work started on the audit mailing list.
It eventually involved touching other modules, so I am trying to
pull in those owners as well. In a nutshell I add new utility
functions for accessing a processes cmdline value as displayed
in proc/<self>/cmdline, and then refactor procfs to use the
utility functions, and then add the ability to the audit subsystem
to record this value.

Thanks for any feedback and help.

[PATCH 1/3] mm: Create utility functions for accessing a tasks
[PATCH 2/3] proc: Update get proc_pid_cmdline() to use mm.h helpers
[PATCH 3/3] audit: Audit proc cmdline value
