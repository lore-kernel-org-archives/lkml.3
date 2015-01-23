Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755690AbbAWPzv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 10:55:51 -0500
Received: from plane.gmane.org ([80.91.229.3]:51292 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751652AbbAWPzt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 10:55:49 -0500
X-Injected-Via-Gmane: http://gmane.org/
Mail-Followup-To: linux-kernel@vger.kernel.org
To: linux-kernel@vger.kernel.org
From: rh_ <richard_hubbe11@lavabit.com>
Subject: [PATCH] groff check uses incorrect mktemp command -- man-pages-3.78
 release
Date: Fri, 23 Jan 2015 07:52:43 -0800
Organization: L2N
Message-ID: <20150123075243.1b798de5@127>
References: <54C20BCA.9040102@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: ip68-6-109-86.sb.sd.cox.net
User-Agent: dsodnetnin
X-Gmane-NNTP-Posting-Host: EZnn0.37p
Original-Received: from slem by 1.1 with local
X-No-Archive: yes
Archive: no
X-Archive: encrypt
X-Operating-System: Barebones_6.1
X-Gmane-NNTP-Posting-Host: 192.168.1.1
X-NNTP-Posting-Host: 192.168.1.1
Mail-Copies-To: never
X-Archive: expiry=79
X-Mailer: EZnn0.37u
X-Newsreader: EZnn0.37u
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- Makefile.orig	2015-01-10 15:48:44.000000000 -0800
+++ Makefile	2015-01-10 15:48:55.000000000 -0800
@@ -57,7 +57,7 @@ install:
 
 # Check if groff reports warnings (may be words of sentances not displayed)
 # from http://lintian.debian.org/tags/manpage-has-errors-from-man.html 
-GROFF_LOG := $(shell mktemp /tmp/manpages-checksXXXX)
+GROFF_LOG := $(shell mktemp /tmp/manpages-checks.XXXXXX)
 check-groff-warnings:
 	for i in man?/*.[1-9]; \
 	do \


