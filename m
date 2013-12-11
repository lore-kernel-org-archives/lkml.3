Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751674Ab3LKQK3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 11:10:29 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:48509 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809Ab3LKQK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 11:10:28 -0500
MIME-Version: 1.0
Date: Wed, 11 Dec 2013 08:10:27 -0800
Message-ID: <CAFftDdoyr1c91rOdh+M6hZKHi7ovkUvs7qeDDBwiaz1KD5tdmQ@mail.gmail.com>
Subject: [RFC] [PATCH] - auditing cmdline
From: William Roberts <bill.c.roberts@gmail.com>
To: "linux-audit@redhat.com" <linux-audit@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Richard Guy Briggs <rgb@redhat.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        Stephen Smalley <sds@tycho.nsa.gov>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

all,

I sent out some patches a while back (12/2) that affect mm, procfs and
audit. The audit patch (PATCH 3/3) was ack'd on by Richard Guy Briggs.
But the other patches I have not heard anything on.

Patches:
[PATCH 1/3] mm: Create utility functions for accessing a tasks commandline value
[PATCH 2/3] proc: Update get proc_pid_cmdline() to use mm.h helpers
[PATCH 3/3  audit: Audit proc cmdline value

Link to mailer archive:
https://www.mail-archive.com/search?l=linux-kernel@vger.kernel.org&q=from:%22William+Roberts%22

Thanks for any help.

-- 
Respectfully,

William C Roberts
