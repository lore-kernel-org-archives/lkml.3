Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753592Ab3KCOVD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 09:21:03 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:34719 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753022Ab3KCOVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 09:21:00 -0500
X-Originating-IP: 109.242.2.94
From: Aldo Iljazi <mail@aldo.io>
To: marek.belisko@gmail.com
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: ft1000: fixed a few styling issues
Date: Sun,  3 Nov 2013 16:20:38 +0200
Message-Id: <1383488438-31477-1-git-send-email-mail@aldo.io>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a few styling issues, specifically:

boot.h:30: ERROR: space prohibited before open square bracket '['
boot.h:31: ERROR: space required after that ',' (ctx:VxV)
boot.h:31: ERROR: space required after that ',' (ctx:VxV)
boot.h:31: ERROR: space required after that ',' (ctx:VxV)
boot.h:31: ERROR: space required after that ',' (ctx:VxV)
boot.h:31: ERROR: space required after that ',' (ctx:VxV)
boot.h:32: ERROR: space required after that ',' (ctx:ExV)
boot.h:32: ERROR: space required after that ',' (ctx:VxV)
boot.h:32: ERROR: space required after that ',' (ctx:VxV)
boot.h:32: ERROR: space required after that ',' (ctx:VxV)
boot.h:32: ERROR: space required after that ',' (ctx:VxV)
boot.h:32: ERROR: space required after that ',' (ctx:VxV)
boot.h:33: ERROR: space required after that ',' (ctx:ExV)
boot.h:33: ERROR: space required after that ',' (ctx:VxV)
boot.h:33: ERROR: space required after that ',' (ctx:VxV)
boot.h:33: ERROR: space required after that ',' (ctx:VxV)
boot.h:33: ERROR: space required after that ',' (ctx:VxV)
boot.h:33: ERROR: space required after that ',' (ctx:VxV)
boot.h:34: ERROR: space required after that ',' (ctx:ExV)
boot.h:34: ERROR: space required after that ',' (ctx:VxV)
boot.h:34: ERROR: space required after that ',' (ctx:VxV)
boot.h:34: ERROR: space required after that ',' (ctx:VxV)
boot.h:34: ERROR: space required after that ',' (ctx:VxV)
boot.h:34: ERROR: space required after that ',' (ctx:VxV)
boot.h:35: ERROR: space required after that ',' (ctx:ExV)
boot.h:35: ERROR: space required after that ',' (ctx:VxV)
boot.h:35: ERROR: space required after that ',' (ctx:VxV)
boot.h:35: ERROR: space required after that ',' (ctx:VxV)
boot.h:35: ERROR: space required after that ',' (ctx:VxV)
boot.h:35: ERROR: space required after that ',' (ctx:VxV)
boot.h:36: ERROR: space required after that ',' (ctx:ExV)
boot.h:36: ERROR: space required after that ',' (ctx:VxV)
boot.h:36: ERROR: space required after that ',' (ctx:VxV)
boot.h:36: ERROR: space required after that ',' (ctx:VxV)
boot.h:36: ERROR: space required after that ',' (ctx:VxV)
boot.h:36: ERROR: space required after that ',' (ctx:VxV)
boot.h:37: ERROR: space required after that ',' (ctx:ExV)
boot.h:37: ERROR: space required after that ',' (ctx:VxV)
boot.h:37: ERROR: space required after that ',' (ctx:VxV)
boot.h:37: ERROR: space required after that ',' (ctx:VxV)
boot.h:37: ERROR: space required after that ',' (ctx:VxV)
boot.h:37: ERROR: space required after that ',' (ctx:VxV)
boot.h:38: ERROR: space required after that ',' (ctx:ExV)
boot.h:38: ERROR: space required after that ',' (ctx:VxV)
boot.h:38: ERROR: space required after that ',' (ctx:VxV)
boot.h:38: ERROR: space required after that ',' (ctx:VxV)
boot.h:38: ERROR: space required after that ',' (ctx:VxV)
boot.h:38: ERROR: space required after that ',' (ctx:VxV)
boot.h:39: ERROR: space required after that ',' (ctx:ExV)
boot.h:39: ERROR: space required after that ',' (ctx:VxV)
boot.h:39: ERROR: space required after that ',' (ctx:VxV)
boot.h:39: ERROR: space required after that ',' (ctx:VxV)
boot.h:39: ERROR: space required after that ',' (ctx:VxV)
boot.h:39: ERROR: space required after that ',' (ctx:VxV)
boot.h:40: ERROR: space required after that ',' (ctx:ExV)
boot.h:40: ERROR: space required after that ',' (ctx:VxV)
boot.h:40: ERROR: space required after that ',' (ctx:VxV)
boot.h:40: ERROR: space required after that ',' (ctx:VxV)
boot.h:40: ERROR: space required after that ',' (ctx:VxV)
boot.h:40: ERROR: space required after that ',' (ctx:VxV)
boot.h:41: ERROR: space required after that ',' (ctx:ExV)
boot.h:41: ERROR: space required after that ',' (ctx:VxV)
boot.h:41: ERROR: space required after that ',' (ctx:VxV)
boot.h:41: ERROR: space required after that ',' (ctx:VxV)
boot.h:41: ERROR: space required after that ',' (ctx:VxV)
boot.h:41: ERROR: space required after that ',' (ctx:VxV)
boot.h:42: ERROR: space required after that ',' (ctx:ExV)
boot.h:42: ERROR: space required after that ',' (ctx:VxV)
boot.h:42: ERROR: space required after that ',' (ctx:VxV)
boot.h:42: ERROR: space required after that ',' (ctx:VxV)
boot.h:42: ERROR: space required after that ',' (ctx:VxV)
boot.h:42: ERROR: space required after that ',' (ctx:VxV)
boot.h:43: ERROR: space required after that ',' (ctx:ExV)
boot.h:43: ERROR: space required after that ',' (ctx:VxV)
boot.h:43: ERROR: space required after that ',' (ctx:VxV)
boot.h:43: ERROR: space required after that ',' (ctx:VxV)
boot.h:43: ERROR: space required after that ',' (ctx:VxV)
boot.h:43: ERROR: space required after that ',' (ctx:VxV)
boot.h:44: ERROR: space required after that ',' (ctx:ExV)
boot.h:44: ERROR: space required after that ',' (ctx:VxV)
boot.h:44: ERROR: space required after that ',' (ctx:VxV)
boot.h:44: ERROR: space required after that ',' (ctx:VxV)
boot.h:44: ERROR: space required after that ',' (ctx:VxV)
boot.h:44: ERROR: space required after that ',' (ctx:VxV)
boot.h:45: ERROR: space required after that ',' (ctx:ExV)
boot.h:45: ERROR: space required after that ',' (ctx:VxV)
boot.h:45: ERROR: space required after that ',' (ctx:VxV)
boot.h:45: ERROR: space required after that ',' (ctx:VxV)
boot.h:45: ERROR: space required after that ',' (ctx:VxV)
boot.h:45: ERROR: space required after that ',' (ctx:VxV)
boot.h:46: ERROR: space required after that ',' (ctx:ExV)
boot.h:46: ERROR: space required after that ',' (ctx:VxV)
boot.h:46: ERROR: space required after that ',' (ctx:VxV)
boot.h:46: ERROR: space required after that ',' (ctx:VxV)
boot.h:46: ERROR: space required after that ',' (ctx:VxV)
boot.h:46: ERROR: space required after that ',' (ctx:VxV)
boot.h:47: ERROR: space required after that ',' (ctx:ExV)
boot.h:47: ERROR: space required after that ',' (ctx:VxV)
boot.h:47: ERROR: space required after that ',' (ctx:VxV)
boot.h:47: ERROR: space required after that ',' (ctx:VxV)
boot.h:47: ERROR: space required after that ',' (ctx:VxV)
boot.h:47: ERROR: space required after that ',' (ctx:VxV)
boot.h:48: ERROR: space required after that ',' (ctx:ExV)
boot.h:48: ERROR: space required after that ',' (ctx:VxV)
boot.h:48: ERROR: space required after that ',' (ctx:VxV)
boot.h:48: ERROR: space required after that ',' (ctx:VxV)
boot.h:48: ERROR: space required after that ',' (ctx:VxV)
boot.h:48: ERROR: space required after that ',' (ctx:VxV)
boot.h:49: ERROR: space required after that ',' (ctx:ExV)
boot.h:49: ERROR: space required after that ',' (ctx:VxV)
boot.h:49: ERROR: space required after that ',' (ctx:VxV)
boot.h:49: ERROR: space required after that ',' (ctx:VxV)
boot.h:49: ERROR: space required after that ',' (ctx:VxV)
boot.h:49: ERROR: space required after that ',' (ctx:VxV)
boot.h:50: ERROR: space required after that ',' (ctx:ExV)
boot.h:50: ERROR: space required after that ',' (ctx:VxV)
boot.h:50: ERROR: space required after that ',' (ctx:VxV)
boot.h:50: ERROR: space required after that ',' (ctx:VxV)
boot.h:50: ERROR: space required after that ',' (ctx:VxV)
boot.h:50: ERROR: space required after that ',' (ctx:VxV)
boot.h:51: ERROR: space required after that ',' (ctx:ExV)
boot.h:51: ERROR: space required after that ',' (ctx:VxV)
boot.h:51: ERROR: space required after that ',' (ctx:VxV)
boot.h:51: ERROR: space required after that ',' (ctx:VxV)
boot.h:51: ERROR: space required after that ',' (ctx:VxV)
boot.h:51: ERROR: space required after that ',' (ctx:VxV)
boot.h:52: ERROR: space required after that ',' (ctx:ExV)
boot.h:52: ERROR: space required after that ',' (ctx:VxV)
boot.h:52: ERROR: space required after that ',' (ctx:VxV)
boot.h:52: ERROR: space required after that ',' (ctx:VxV)
boot.h:52: ERROR: space required after that ',' (ctx:VxV)
boot.h:52: ERROR: space required after that ',' (ctx:VxV)
boot.h:53: ERROR: space required after that ',' (ctx:ExV)
boot.h:53: ERROR: space required after that ',' (ctx:VxV)
boot.h:53: ERROR: space required after that ',' (ctx:VxV)
boot.h:53: ERROR: space required after that ',' (ctx:VxV)
boot.h:53: ERROR: space required after that ',' (ctx:VxV)
boot.h:53: ERROR: space required after that ',' (ctx:VxV)
boot.h:54: ERROR: space required after that ',' (ctx:ExV)
boot.h:54: ERROR: space required after that ',' (ctx:VxV)
boot.h:54: ERROR: space required after that ',' (ctx:VxV)
boot.h:54: ERROR: space required after that ',' (ctx:VxV)
boot.h:54: ERROR: space required after that ',' (ctx:VxV)
boot.h:54: ERROR: space required after that ',' (ctx:VxV)
boot.h:55: ERROR: space required after that ',' (ctx:ExV)
boot.h:55: ERROR: space required after that ',' (ctx:VxV)
boot.h:55: ERROR: space required after that ',' (ctx:VxV)
boot.h:55: ERROR: space required after that ',' (ctx:VxV)
boot.h:55: ERROR: space required after that ',' (ctx:VxV)
boot.h:55: ERROR: space required after that ',' (ctx:VxV)
boot.h:56: ERROR: space required after that ',' (ctx:ExV)
boot.h:56: ERROR: space required after that ',' (ctx:VxV)
boot.h:56: ERROR: space required after that ',' (ctx:VxV)
boot.h:56: ERROR: space required after that ',' (ctx:VxV)
boot.h:56: ERROR: space required after that ',' (ctx:VxV)
boot.h:56: ERROR: space required after that ',' (ctx:VxV)
boot.h:57: ERROR: space required after that ',' (ctx:ExV)
boot.h:57: ERROR: space required after that ',' (ctx:VxV)
boot.h:57: ERROR: space required after that ',' (ctx:VxV)
boot.h:57: ERROR: space required after that ',' (ctx:VxV)
boot.h:57: ERROR: space required after that ',' (ctx:VxV)
boot.h:57: ERROR: space required after that ',' (ctx:VxV)
boot.h:58: ERROR: space required after that ',' (ctx:ExV)
boot.h:58: ERROR: space required after that ',' (ctx:VxV)
boot.h:58: ERROR: space required after that ',' (ctx:VxV)
boot.h:58: ERROR: space required after that ',' (ctx:VxV)
boot.h:58: ERROR: space required after that ',' (ctx:VxV)
boot.h:58: ERROR: space required after that ',' (ctx:VxV)
boot.h:59: ERROR: space required after that ',' (ctx:ExV)
boot.h:59: ERROR: space required after that ',' (ctx:VxV)
boot.h:59: ERROR: space required after that ',' (ctx:VxV)
boot.h:59: ERROR: space required after that ',' (ctx:VxV)
boot.h:59: ERROR: space required after that ',' (ctx:VxV)
boot.h:59: ERROR: space required after that ',' (ctx:VxV)
boot.h:60: ERROR: space required after that ',' (ctx:ExV)
boot.h:60: ERROR: space required after that ',' (ctx:VxV)
boot.h:60: ERROR: space required after that ',' (ctx:VxV)
boot.h:60: ERROR: space required after that ',' (ctx:VxV)
boot.h:60: ERROR: space required after that ',' (ctx:VxV)
boot.h:60: ERROR: space required after that ',' (ctx:VxV)
boot.h:61: ERROR: space required after that ',' (ctx:ExV)
boot.h:61: ERROR: space required after that ',' (ctx:VxV)
boot.h:61: ERROR: space required after that ',' (ctx:VxV)
boot.h:61: ERROR: space required after that ',' (ctx:VxV)
boot.h:61: ERROR: space required after that ',' (ctx:VxV)
boot.h:61: ERROR: space required after that ',' (ctx:VxV)
boot.h:62: ERROR: space required after that ',' (ctx:ExV)
boot.h:62: ERROR: space required after that ',' (ctx:VxV)
boot.h:62: ERROR: space required after that ',' (ctx:VxV)
boot.h:62: ERROR: space required after that ',' (ctx:VxV)
boot.h:62: ERROR: space required after that ',' (ctx:VxV)
boot.h:62: ERROR: space required after that ',' (ctx:VxV)
boot.h:63: ERROR: space required after that ',' (ctx:ExV)
boot.h:63: ERROR: space required after that ',' (ctx:VxV)
boot.h:63: ERROR: space required after that ',' (ctx:VxV)
boot.h:63: ERROR: space required after that ',' (ctx:VxV)
boot.h:63: ERROR: space required after that ',' (ctx:VxV)
boot.h:63: ERROR: space required after that ',' (ctx:VxV)
boot.h:64: ERROR: space required after that ',' (ctx:ExV)
boot.h:64: ERROR: space required after that ',' (ctx:VxV)
boot.h:64: ERROR: space required after that ',' (ctx:VxV)
boot.h:64: ERROR: space required after that ',' (ctx:VxV)
boot.h:64: ERROR: space required after that ',' (ctx:VxV)
boot.h:64: ERROR: space required after that ',' (ctx:VxV)
boot.h:65: ERROR: space required after that ',' (ctx:ExV)
boot.h:65: ERROR: space required after that ',' (ctx:VxV)
boot.h:65: ERROR: space required after that ',' (ctx:VxV)
boot.h:65: ERROR: space required after that ',' (ctx:VxV)
boot.h:65: ERROR: space required after that ',' (ctx:VxV)
boot.h:65: ERROR: space required after that ',' (ctx:VxV)
boot.h:66: ERROR: space required after that ',' (ctx:ExV)
boot.h:66: ERROR: space required after that ',' (ctx:VxV)
boot.h:66: ERROR: space required after that ',' (ctx:VxV)
boot.h:66: ERROR: space required after that ',' (ctx:VxV)
boot.h:66: ERROR: space required after that ',' (ctx:VxV)
boot.h:66: ERROR: space required after that ',' (ctx:VxV)
boot.h:67: ERROR: space required after that ',' (ctx:ExV)
boot.h:67: ERROR: space required after that ',' (ctx:VxV)
boot.h:67: ERROR: space required after that ',' (ctx:VxV)
boot.h:67: ERROR: space required after that ',' (ctx:VxV)
boot.h:67: ERROR: space required after that ',' (ctx:VxV)
boot.h:67: ERROR: space required after that ',' (ctx:VxV)
boot.h:68: ERROR: space required after that ',' (ctx:ExV)
boot.h:68: ERROR: space required after that ',' (ctx:VxV)
boot.h:68: ERROR: space required after that ',' (ctx:VxV)
boot.h:68: ERROR: space required after that ',' (ctx:VxV)
boot.h:68: ERROR: space required after that ',' (ctx:VxV)
boot.h:68: ERROR: space required after that ',' (ctx:VxV)
boot.h:69: ERROR: space required after that ',' (ctx:ExV)
boot.h:69: ERROR: space required after that ',' (ctx:VxV)
boot.h:69: ERROR: space required after that ',' (ctx:VxV)
boot.h:69: ERROR: space required after that ',' (ctx:VxV)
boot.h:69: ERROR: space required after that ',' (ctx:VxV)
boot.h:69: ERROR: space required after that ',' (ctx:VxV)
boot.h:70: ERROR: space required after that ',' (ctx:ExV)
boot.h:70: ERROR: space required after that ',' (ctx:VxV)
boot.h:70: ERROR: space required after that ',' (ctx:VxV)
boot.h:70: ERROR: space required after that ',' (ctx:VxV)
boot.h:70: ERROR: space required after that ',' (ctx:VxV)
boot.h:70: ERROR: space required after that ',' (ctx:VxV)
boot.h:71: ERROR: space required after that ',' (ctx:ExV)
boot.h:71: ERROR: space required after that ',' (ctx:VxV)
boot.h:71: ERROR: space required after that ',' (ctx:VxV)
boot.h:71: ERROR: space required after that ',' (ctx:VxV)
boot.h:71: ERROR: space required after that ',' (ctx:VxV)
boot.h:71: ERROR: space required after that ',' (ctx:VxV)
boot.h:72: ERROR: space required after that ',' (ctx:ExV)
boot.h:72: ERROR: space required after that ',' (ctx:VxV)
boot.h:72: ERROR: space required after that ',' (ctx:VxV)
boot.h:72: ERROR: space required after that ',' (ctx:VxV)
boot.h:72: ERROR: space required after that ',' (ctx:VxV)
boot.h:72: ERROR: space required after that ',' (ctx:VxV)
boot.h:73: ERROR: space required after that ',' (ctx:ExV)
boot.h:73: ERROR: space required after that ',' (ctx:VxV)
boot.h:73: ERROR: space required after that ',' (ctx:VxV)
boot.h:73: ERROR: space required after that ',' (ctx:VxV)
boot.h:73: ERROR: space required after that ',' (ctx:VxV)
boot.h:73: ERROR: space required after that ',' (ctx:VxV)
boot.h:74: ERROR: space required after that ',' (ctx:ExV)
boot.h:74: ERROR: space required after that ',' (ctx:VxV)
boot.h:74: ERROR: space required after that ',' (ctx:VxV)
boot.h:74: ERROR: space required after that ',' (ctx:VxV)
boot.h:74: ERROR: space required after that ',' (ctx:VxV)
boot.h:74: ERROR: space required after that ',' (ctx:VxV)
boot.h:75: ERROR: space required after that ',' (ctx:ExV)
boot.h:75: ERROR: space required after that ',' (ctx:VxV)
boot.h:75: ERROR: space required after that ',' (ctx:VxV)
boot.h:75: ERROR: space required after that ',' (ctx:VxV)
boot.h:75: ERROR: space required after that ',' (ctx:VxV)
boot.h:75: ERROR: space required after that ',' (ctx:VxV)
boot.h:76: ERROR: space required after that ',' (ctx:ExV)
boot.h:76: ERROR: space required after that ',' (ctx:VxV)
boot.h:76: ERROR: space required after that ',' (ctx:VxV)
boot.h:76: ERROR: space required after that ',' (ctx:VxV)
boot.h:76: ERROR: space required after that ',' (ctx:VxV)
boot.h:76: ERROR: space required after that ',' (ctx:VxV)
boot.h:77: ERROR: space required after that ',' (ctx:ExV)
boot.h:77: ERROR: space required after that ',' (ctx:VxV)
boot.h:77: ERROR: space required after that ',' (ctx:VxV)
boot.h:77: ERROR: space required after that ',' (ctx:VxV)
boot.h:77: ERROR: space required after that ',' (ctx:VxV)
boot.h:77: ERROR: space required after that ',' (ctx:VxV)
boot.h:78: ERROR: space required after that ',' (ctx:ExV)
boot.h:78: ERROR: space required after that ',' (ctx:VxV)
boot.h:78: ERROR: space required after that ',' (ctx:VxV)
boot.h:78: ERROR: space required after that ',' (ctx:VxV)
boot.h:78: ERROR: space required after that ',' (ctx:VxV)
boot.h:78: ERROR: space required after that ',' (ctx:VxV)
boot.h:79: ERROR: space required after that ',' (ctx:ExV)
boot.h:79: ERROR: space required after that ',' (ctx:VxV)
boot.h:79: ERROR: space required after that ',' (ctx:VxV)
boot.h:79: ERROR: space required after that ',' (ctx:VxV)
boot.h:79: ERROR: space required after that ',' (ctx:VxV)
boot.h:79: ERROR: space required after that ',' (ctx:VxV)
boot.h:80: ERROR: space required after that ',' (ctx:ExV)
boot.h:80: ERROR: space required after that ',' (ctx:VxV)
boot.h:80: ERROR: space required after that ',' (ctx:VxV)
boot.h:80: ERROR: space required after that ',' (ctx:VxV)
boot.h:80: ERROR: space required after that ',' (ctx:VxV)
boot.h:80: ERROR: space required after that ',' (ctx:VxV)
boot.h:81: ERROR: space required after that ',' (ctx:ExV)
boot.h:81: ERROR: space required after that ',' (ctx:VxV)
boot.h:81: ERROR: space required after that ',' (ctx:VxV)
boot.h:81: ERROR: space required after that ',' (ctx:VxV)
boot.h:81: ERROR: space required after that ',' (ctx:VxV)
boot.h:81: ERROR: space required after that ',' (ctx:VxV)
boot.h:82: ERROR: space required after that ',' (ctx:ExV)
boot.h:82: ERROR: space required after that ',' (ctx:VxV)
boot.h:82: ERROR: space required after that ',' (ctx:VxV)
boot.h:82: ERROR: space required after that ',' (ctx:VxV)
boot.h:82: ERROR: space required after that ',' (ctx:VxV)
boot.h:82: ERROR: space required after that ',' (ctx:VxV)
boot.h:83: ERROR: space required after that ',' (ctx:ExV)
boot.h:83: ERROR: space required after that ',' (ctx:VxV)
boot.h:83: ERROR: space required after that ',' (ctx:VxV)
boot.h:83: ERROR: space required after that ',' (ctx:VxV)
boot.h:83: ERROR: space required after that ',' (ctx:VxV)
boot.h:83: ERROR: space required after that ',' (ctx:VxV)
boot.h:84: ERROR: space required after that ',' (ctx:ExV)
boot.h:84: ERROR: space required after that ',' (ctx:VxV)
boot.h:84: ERROR: space required after that ',' (ctx:VxV)
boot.h:84: ERROR: space required after that ',' (ctx:VxV)
boot.h:84: ERROR: space required after that ',' (ctx:VxV)
boot.h:84: ERROR: space required after that ',' (ctx:VxV)
boot.h:85: ERROR: space required after that ',' (ctx:ExV)
boot.h:85: ERROR: space required after that ',' (ctx:VxV)
boot.h:85: ERROR: space required after that ',' (ctx:VxV)
boot.h:85: ERROR: space required after that ',' (ctx:VxV)
boot.h:85: ERROR: space required after that ',' (ctx:VxV)
boot.h:85: ERROR: space required after that ',' (ctx:VxV)
boot.h:86: ERROR: space required after that ',' (ctx:ExV)
boot.h:86: ERROR: space required after that ',' (ctx:VxV)
boot.h:86: ERROR: space required after that ',' (ctx:VxV)
boot.h:86: ERROR: space required after that ',' (ctx:VxV)
boot.h:86: ERROR: space required after that ',' (ctx:VxV)
boot.h:86: ERROR: space required after that ',' (ctx:VxV)
boot.h:87: ERROR: space required after that ',' (ctx:ExV)
boot.h:87: ERROR: space required after that ',' (ctx:VxV)
boot.h:87: ERROR: space required after that ',' (ctx:VxV)
boot.h:87: ERROR: space required after that ',' (ctx:VxV)
boot.h:87: ERROR: space required after that ',' (ctx:VxV)
boot.h:87: ERROR: space required after that ',' (ctx:VxV)
boot.h:88: ERROR: space required after that ',' (ctx:ExV)
boot.h:88: ERROR: space required after that ',' (ctx:VxV)
boot.h:88: ERROR: space required after that ',' (ctx:VxV)
boot.h:88: ERROR: space required after that ',' (ctx:VxV)
boot.h:88: ERROR: space required after that ',' (ctx:VxV)
boot.h:88: ERROR: space required after that ',' (ctx:VxV)
boot.h:89: ERROR: space required after that ',' (ctx:ExV)
boot.h:89: ERROR: space required after that ',' (ctx:VxV)
boot.h:89: ERROR: space required after that ',' (ctx:VxV)
boot.h:89: ERROR: space required after that ',' (ctx:VxV)
boot.h:89: ERROR: space required after that ',' (ctx:VxV)
boot.h:89: ERROR: space required after that ',' (ctx:VxV)
boot.h:90: ERROR: space required after that ',' (ctx:ExV)
boot.h:90: ERROR: space required after that ',' (ctx:VxV)
boot.h:90: ERROR: space required after that ',' (ctx:VxV)
boot.h:90: ERROR: space required after that ',' (ctx:VxV)
boot.h:90: ERROR: space required after that ',' (ctx:VxV)
boot.h:90: ERROR: space required after that ',' (ctx:VxV)
boot.h:91: ERROR: space required after that ',' (ctx:ExV)
boot.h:91: ERROR: space required after that ',' (ctx:VxV)
boot.h:91: ERROR: space required after that ',' (ctx:VxV)
boot.h:91: ERROR: space required after that ',' (ctx:VxV)
boot.h:91: ERROR: space required after that ',' (ctx:VxV)
boot.h:91: ERROR: space required after that ',' (ctx:VxV)
boot.h:92: ERROR: space required after that ',' (ctx:ExV)
boot.h:92: ERROR: space required after that ',' (ctx:VxV)
boot.h:92: ERROR: space required after that ',' (ctx:VxV)
boot.h:92: ERROR: space required after that ',' (ctx:VxV)
boot.h:92: ERROR: space required after that ',' (ctx:VxV)
boot.h:92: ERROR: space required after that ',' (ctx:VxV)
boot.h:93: ERROR: space required after that ',' (ctx:ExV)
boot.h:93: ERROR: space required after that ',' (ctx:VxV)
boot.h:93: ERROR: space required after that ',' (ctx:VxV)
boot.h:93: ERROR: space required after that ',' (ctx:VxV)
boot.h:93: ERROR: space required after that ',' (ctx:VxV)
boot.h:93: ERROR: space required after that ',' (ctx:VxV)
boot.h:94: ERROR: space required after that ',' (ctx:ExV)
boot.h:94: ERROR: space required after that ',' (ctx:VxV)
boot.h:94: ERROR: space required after that ',' (ctx:VxV)
boot.h:94: ERROR: space required after that ',' (ctx:VxV)
boot.h:94: ERROR: space required after that ',' (ctx:VxV)
boot.h:94: ERROR: space required after that ',' (ctx:VxV)
boot.h:95: ERROR: space required after that ',' (ctx:ExV)
boot.h:95: ERROR: space required after that ',' (ctx:VxV)
boot.h:95: ERROR: space required after that ',' (ctx:VxV)
boot.h:95: ERROR: space required after that ',' (ctx:VxV)
boot.h:95: ERROR: space required after that ',' (ctx:VxV)
boot.h:95: ERROR: space required after that ',' (ctx:VxV)
boot.h:96: ERROR: space required after that ',' (ctx:ExV)
boot.h:96: ERROR: space required after that ',' (ctx:VxV)
boot.h:96: ERROR: space required after that ',' (ctx:VxV)
boot.h:96: ERROR: space required after that ',' (ctx:VxV)
boot.h:96: ERROR: space required after that ',' (ctx:VxV)
boot.h:96: ERROR: space required after that ',' (ctx:VxV)
boot.h:97: ERROR: space required after that ',' (ctx:ExV)
boot.h:97: ERROR: space required after that ',' (ctx:VxV)
boot.h:97: ERROR: space required after that ',' (ctx:VxV)
boot.h:97: ERROR: space required after that ',' (ctx:VxV)
boot.h:97: ERROR: space required after that ',' (ctx:VxV)
boot.h:97: ERROR: space required after that ',' (ctx:VxV)
boot.h:98: ERROR: space required after that ',' (ctx:ExV)
boot.h:98: ERROR: space required after that ',' (ctx:VxV)
boot.h:98: ERROR: space required after that ',' (ctx:VxV)
boot.h:98: ERROR: space required after that ',' (ctx:VxV)
boot.h:98: ERROR: space required after that ',' (ctx:VxV)
boot.h:98: ERROR: space required after that ',' (ctx:VxV)
boot.h:99: ERROR: space required after that ',' (ctx:ExV)
boot.h:99: ERROR: space required after that ',' (ctx:VxV)
boot.h:99: ERROR: space required after that ',' (ctx:VxV)
boot.h:99: ERROR: space required after that ',' (ctx:VxV)
boot.h:99: ERROR: space required after that ',' (ctx:VxV)
boot.h:99: ERROR: space required after that ',' (ctx:VxV)
boot.h:100: ERROR: space required after that ',' (ctx:ExV)
boot.h:100: ERROR: space required after that ',' (ctx:VxV)
boot.h:100: ERROR: space required after that ',' (ctx:VxV)
boot.h:100: ERROR: space required after that ',' (ctx:VxV)
boot.h:100: ERROR: space required after that ',' (ctx:VxV)
boot.h:100: ERROR: space required after that ',' (ctx:VxV)
boot.h:101: ERROR: space required after that ',' (ctx:ExV)
boot.h:101: ERROR: space required after that ',' (ctx:VxV)
boot.h:101: ERROR: space required after that ',' (ctx:VxV)
boot.h:101: ERROR: space required after that ',' (ctx:VxV)
boot.h:101: ERROR: space required after that ',' (ctx:VxV)
boot.h:101: ERROR: space required after that ',' (ctx:VxV)
boot.h:102: ERROR: space required after that ',' (ctx:ExV)
boot.h:102: ERROR: space required after that ',' (ctx:VxV)
boot.h:102: ERROR: space required after that ',' (ctx:VxV)
boot.h:102: ERROR: space required after that ',' (ctx:VxV)
boot.h:102: ERROR: space required after that ',' (ctx:VxV)
boot.h:102: ERROR: space required after that ',' (ctx:VxV)
boot.h:103: ERROR: space required after that ',' (ctx:ExV)
boot.h:103: ERROR: space required after that ',' (ctx:VxV)
boot.h:103: ERROR: space required after that ',' (ctx:VxV)
boot.h:103: ERROR: space required after that ',' (ctx:VxV)
boot.h:103: ERROR: space required after that ',' (ctx:VxV)
boot.h:103: ERROR: space required after that ',' (ctx:VxV)
boot.h:104: ERROR: space required after that ',' (ctx:ExV)
boot.h:104: ERROR: space required after that ',' (ctx:VxV)
boot.h:104: ERROR: space required after that ',' (ctx:VxV)
boot.h:104: ERROR: space required after that ',' (ctx:VxV)
boot.h:104: ERROR: space required after that ',' (ctx:VxV)
boot.h:104: ERROR: space required after that ',' (ctx:VxV)
boot.h:105: ERROR: space required after that ',' (ctx:ExV)
boot.h:105: ERROR: space required after that ',' (ctx:VxV)
boot.h:105: ERROR: space required after that ',' (ctx:VxV)
boot.h:105: ERROR: space required after that ',' (ctx:VxV)
boot.h:105: ERROR: space required after that ',' (ctx:VxV)
boot.h:105: ERROR: space required after that ',' (ctx:VxV)
boot.h:106: ERROR: space required after that ',' (ctx:ExV)
boot.h:106: ERROR: space required after that ',' (ctx:VxV)
boot.h:106: ERROR: space required after that ',' (ctx:VxV)
boot.h:106: ERROR: space required after that ',' (ctx:VxV)
boot.h:106: ERROR: space required after that ',' (ctx:VxV)
boot.h:106: ERROR: space required after that ',' (ctx:VxV)
boot.h:107: ERROR: space required after that ',' (ctx:ExV)
boot.h:107: ERROR: space required after that ',' (ctx:VxV)
boot.h:107: ERROR: space required after that ',' (ctx:VxV)
boot.h:107: ERROR: space required after that ',' (ctx:VxV)
boot.h:107: ERROR: space required after that ',' (ctx:VxV)
boot.h:107: ERROR: space required after that ',' (ctx:VxV)
boot.h:108: ERROR: space required after that ',' (ctx:ExV)
boot.h:108: ERROR: space required after that ',' (ctx:VxV)
boot.h:108: ERROR: space required after that ',' (ctx:VxV)
boot.h:108: ERROR: space required after that ',' (ctx:VxV)
boot.h:108: ERROR: space required after that ',' (ctx:VxV)
boot.h:108: ERROR: space required after that ',' (ctx:VxV)
boot.h:109: ERROR: space required after that ',' (ctx:ExV)
boot.h:109: ERROR: space required after that ',' (ctx:VxV)
boot.h:109: ERROR: space required after that ',' (ctx:VxV)
boot.h:109: ERROR: space required after that ',' (ctx:VxV)
boot.h:109: ERROR: space required after that ',' (ctx:VxV)
boot.h:109: ERROR: space required after that ',' (ctx:VxV)
boot.h:110: ERROR: space required after that ',' (ctx:ExV)
boot.h:110: ERROR: space required after that ',' (ctx:VxV)
boot.h:110: ERROR: space required after that ',' (ctx:VxV)
boot.h:110: ERROR: space required after that ',' (ctx:VxV)
boot.h:110: ERROR: space required after that ',' (ctx:VxV)
boot.h:110: ERROR: space required after that ',' (ctx:VxV)
boot.h:111: ERROR: space required after that ',' (ctx:ExV)
boot.h:111: ERROR: space required after that ',' (ctx:VxV)
boot.h:111: ERROR: space required after that ',' (ctx:VxV)
boot.h:111: ERROR: space required after that ',' (ctx:VxV)
boot.h:111: ERROR: space required after that ',' (ctx:VxV)
boot.h:111: ERROR: space required after that ',' (ctx:VxV)
boot.h:112: ERROR: space required after that ',' (ctx:ExV)
boot.h:112: ERROR: space required after that ',' (ctx:VxV)
boot.h:112: ERROR: space required after that ',' (ctx:VxV)
boot.h:112: ERROR: space required after that ',' (ctx:VxV)
boot.h:112: ERROR: space required after that ',' (ctx:VxV)
boot.h:112: ERROR: space required after that ',' (ctx:VxV)
boot.h:113: ERROR: space required after that ',' (ctx:ExV)
boot.h:113: ERROR: space required after that ',' (ctx:VxV)
boot.h:113: ERROR: space required after that ',' (ctx:VxV)
boot.h:113: ERROR: space required after that ',' (ctx:VxV)
boot.h:113: ERROR: space required after that ',' (ctx:VxV)
boot.h:113: ERROR: space required after that ',' (ctx:VxV)
boot.h:114: ERROR: space required after that ',' (ctx:ExV)
boot.h:114: ERROR: space required after that ',' (ctx:VxV)
boot.h:114: ERROR: space required after that ',' (ctx:VxV)
boot.h:114: ERROR: space required after that ',' (ctx:VxV)
boot.h:114: ERROR: space required after that ',' (ctx:VxV)
boot.h:114: ERROR: space required after that ',' (ctx:VxV)
boot.h:115: ERROR: space required after that ',' (ctx:ExV)
boot.h:115: ERROR: space required after that ',' (ctx:VxV)
boot.h:115: ERROR: space required after that ',' (ctx:VxV)
boot.h:115: ERROR: space required after that ',' (ctx:VxV)
boot.h:115: ERROR: space required after that ',' (ctx:VxV)
boot.h:115: ERROR: space required after that ',' (ctx:VxV)
boot.h:116: ERROR: space required after that ',' (ctx:ExV)
boot.h:116: ERROR: space required after that ',' (ctx:VxV)
boot.h:116: ERROR: space required after that ',' (ctx:VxV)
boot.h:116: ERROR: space required after that ',' (ctx:VxV)
boot.h:116: ERROR: space required after that ',' (ctx:VxV)
boot.h:116: ERROR: space required after that ',' (ctx:VxV)
boot.h:117: ERROR: space required after that ',' (ctx:ExV)
boot.h:117: ERROR: space required after that ',' (ctx:VxV)
boot.h:117: ERROR: space required after that ',' (ctx:VxV)
boot.h:117: ERROR: space required after that ',' (ctx:VxV)
boot.h:117: ERROR: space required after that ',' (ctx:VxV)
boot.h:117: ERROR: space required after that ',' (ctx:VxV)
boot.h:118: ERROR: space required after that ',' (ctx:ExV)
boot.h:118: ERROR: space required after that ',' (ctx:VxV)
boot.h:118: ERROR: space required after that ',' (ctx:VxV)
boot.h:118: ERROR: space required after that ',' (ctx:VxV)
boot.h:118: ERROR: space required after that ',' (ctx:VxV)
boot.h:118: ERROR: space required after that ',' (ctx:VxV)
boot.h:119: ERROR: space required after that ',' (ctx:ExV)
boot.h:119: ERROR: space required after that ',' (ctx:VxV)
boot.h:119: ERROR: space required after that ',' (ctx:VxV)
boot.h:119: ERROR: space required after that ',' (ctx:VxV)
boot.h:119: ERROR: space required after that ',' (ctx:VxV)
boot.h:119: ERROR: space required after that ',' (ctx:VxV)
boot.h:120: ERROR: space required after that ',' (ctx:ExV)
boot.h:120: ERROR: space required after that ',' (ctx:VxV)
boot.h:120: ERROR: space required after that ',' (ctx:VxV)
boot.h:120: ERROR: space required after that ',' (ctx:VxV)
boot.h:120: ERROR: space required after that ',' (ctx:VxV)
boot.h:120: ERROR: space required after that ',' (ctx:VxV)
boot.h:121: ERROR: space required after that ',' (ctx:ExV)
boot.h:121: ERROR: space required after that ',' (ctx:VxV)
boot.h:121: ERROR: space required after that ',' (ctx:VxV)
boot.h:121: ERROR: space required after that ',' (ctx:VxV)
boot.h:121: ERROR: space required after that ',' (ctx:VxV)
boot.h:121: ERROR: space required after that ',' (ctx:VxV)
boot.h:122: ERROR: space required after that ',' (ctx:ExV)
boot.h:122: ERROR: space required after that ',' (ctx:VxV)
boot.h:122: ERROR: space required after that ',' (ctx:VxV)
boot.h:122: ERROR: space required after that ',' (ctx:VxV)
boot.h:122: ERROR: space required after that ',' (ctx:VxV)
boot.h:122: ERROR: space required after that ',' (ctx:VxV)
boot.h:123: ERROR: space required after that ',' (ctx:ExV)
boot.h:123: ERROR: space required after that ',' (ctx:VxV)
boot.h:123: ERROR: space required after that ',' (ctx:VxV)
boot.h:123: ERROR: space required after that ',' (ctx:VxV)
boot.h:123: ERROR: space required after that ',' (ctx:VxV)
boot.h:123: ERROR: space required after that ',' (ctx:VxV)
boot.h:124: ERROR: space required after that ',' (ctx:ExV)
boot.h:124: ERROR: space required after that ',' (ctx:VxV)
boot.h:124: ERROR: space required after that ',' (ctx:VxV)
boot.h:124: ERROR: space required after that ',' (ctx:VxV)
boot.h:124: ERROR: space required after that ',' (ctx:VxV)
boot.h:124: ERROR: space required after that ',' (ctx:VxV)
boot.h:125: ERROR: space required after that ',' (ctx:ExV)
boot.h:125: ERROR: space required after that ',' (ctx:VxV)
boot.h:125: ERROR: space required after that ',' (ctx:VxV)
boot.h:125: ERROR: space required after that ',' (ctx:VxV)
boot.h:125: ERROR: space required after that ',' (ctx:VxV)
boot.h:125: ERROR: space required after that ',' (ctx:VxV)
boot.h:126: ERROR: space required after that ',' (ctx:ExV)
boot.h:126: ERROR: space required after that ',' (ctx:VxV)
boot.h:126: ERROR: space required after that ',' (ctx:VxV)
boot.h:126: ERROR: space required after that ',' (ctx:VxV)
boot.h:126: ERROR: space required after that ',' (ctx:VxV)
boot.h:126: ERROR: space required after that ',' (ctx:VxV)
boot.h:127: ERROR: space required after that ',' (ctx:ExV)
boot.h:127: ERROR: space required after that ',' (ctx:VxV)
boot.h:127: ERROR: space required after that ',' (ctx:VxV)
boot.h:127: ERROR: space required after that ',' (ctx:VxV)
boot.h:127: ERROR: space required after that ',' (ctx:VxV)
boot.h:127: ERROR: space required after that ',' (ctx:VxV)
boot.h:128: ERROR: space required after that ',' (ctx:ExV)
boot.h:128: ERROR: space required after that ',' (ctx:VxV)
boot.h:128: ERROR: space required after that ',' (ctx:VxV)
boot.h:128: ERROR: space required after that ',' (ctx:VxV)
boot.h:128: ERROR: space required after that ',' (ctx:VxV)
boot.h:128: ERROR: space required after that ',' (ctx:VxV)
boot.h:129: ERROR: space required after that ',' (ctx:ExV)
boot.h:129: ERROR: space required after that ',' (ctx:VxV)
boot.h:129: ERROR: space required after that ',' (ctx:VxV)
boot.h:129: ERROR: space required after that ',' (ctx:VxV)
boot.h:129: ERROR: space required after that ',' (ctx:VxV)
boot.h:129: ERROR: space required after that ',' (ctx:VxV)
boot.h:130: ERROR: space required after that ',' (ctx:ExV)
boot.h:130: ERROR: space required after that ',' (ctx:VxV)
boot.h:130: ERROR: space required after that ',' (ctx:VxV)
boot.h:130: ERROR: space required after that ',' (ctx:VxV)
boot.h:130: ERROR: space required after that ',' (ctx:VxV)
boot.h:130: ERROR: space required after that ',' (ctx:VxV)
boot.h:131: ERROR: space required after that ',' (ctx:ExV)
boot.h:131: ERROR: space required after that ',' (ctx:VxV)
boot.h:131: ERROR: space required after that ',' (ctx:VxV)
boot.h:131: ERROR: space required after that ',' (ctx:VxV)
boot.h:131: ERROR: space required after that ',' (ctx:VxV)
boot.h:131: ERROR: space required after that ',' (ctx:VxV)
boot.h:132: ERROR: space required after that ',' (ctx:ExV)
boot.h:132: ERROR: space required after that ',' (ctx:VxV)
boot.h:132: ERROR: space required after that ',' (ctx:VxV)
boot.h:132: ERROR: space required after that ',' (ctx:VxV)
boot.h:132: ERROR: space required after that ',' (ctx:VxV)
boot.h:132: ERROR: space required after that ',' (ctx:VxV)
boot.h:133: ERROR: space required after that ',' (ctx:ExV)
boot.h:133: ERROR: space required after that ',' (ctx:VxV)
boot.h:133: ERROR: space required after that ',' (ctx:VxV)
boot.h:133: ERROR: space required after that ',' (ctx:VxV)
boot.h:133: ERROR: space required after that ',' (ctx:VxV)
boot.h:133: ERROR: space required after that ',' (ctx:VxV)
boot.h:134: ERROR: space required after that ',' (ctx:ExV)
boot.h:134: ERROR: space required after that ',' (ctx:VxV)
boot.h:134: ERROR: space required after that ',' (ctx:VxV)
boot.h:134: ERROR: space required after that ',' (ctx:VxV)
boot.h:134: ERROR: space required after that ',' (ctx:VxV)
boot.h:134: ERROR: space required after that ',' (ctx:VxV)
boot.h:135: ERROR: space required after that ',' (ctx:ExV)
boot.h:135: ERROR: space required after that ',' (ctx:VxV)
boot.h:135: ERROR: space required after that ',' (ctx:VxV)
boot.h:135: ERROR: space required after that ',' (ctx:VxV)
boot.h:135: ERROR: space required after that ',' (ctx:VxV)
boot.h:135: ERROR: space required after that ',' (ctx:VxV)
boot.h:136: ERROR: space required after that ',' (ctx:ExV)
boot.h:136: ERROR: space required after that ',' (ctx:VxV)
boot.h:136: ERROR: space required after that ',' (ctx:VxV)
boot.h:136: ERROR: space required after that ',' (ctx:VxV)
boot.h:136: ERROR: space required after that ',' (ctx:VxV)
boot.h:136: ERROR: space required after that ',' (ctx:VxV)
boot.h:137: ERROR: space required after that ',' (ctx:ExV)
boot.h:137: ERROR: space required after that ',' (ctx:VxV)
boot.h:137: ERROR: space required after that ',' (ctx:VxV)
boot.h:137: ERROR: space required after that ',' (ctx:VxV)
boot.h:137: ERROR: space required after that ',' (ctx:VxV)
boot.h:137: ERROR: space required after that ',' (ctx:VxV)
boot.h:138: ERROR: space required after that ',' (ctx:ExV)
boot.h:138: ERROR: space required after that ',' (ctx:VxV)
boot.h:138: ERROR: space required after that ',' (ctx:VxV)
boot.h:138: ERROR: space required after that ',' (ctx:VxV)
boot.h:138: ERROR: space required after that ',' (ctx:VxV)
boot.h:138: ERROR: space required after that ',' (ctx:VxV)
boot.h:139: ERROR: space required after that ',' (ctx:ExV)
boot.h:139: ERROR: space required after that ',' (ctx:VxV)
boot.h:139: ERROR: space required after that ',' (ctx:VxV)
boot.h:139: ERROR: space required after that ',' (ctx:VxV)
boot.h:139: ERROR: space required after that ',' (ctx:VxV)
boot.h:139: ERROR: space required after that ',' (ctx:VxV)
boot.h:140: ERROR: space required after that ',' (ctx:ExV)
boot.h:140: ERROR: space required after that ',' (ctx:VxV)
boot.h:140: ERROR: space required after that ',' (ctx:VxV)
boot.h:140: ERROR: space required after that ',' (ctx:VxV)
boot.h:140: ERROR: space required after that ',' (ctx:VxV)
boot.h:140: ERROR: space required after that ',' (ctx:VxV)
boot.h:141: ERROR: space required after that ',' (ctx:ExV)
boot.h:141: ERROR: space required after that ',' (ctx:VxV)
boot.h:141: ERROR: space required after that ',' (ctx:VxV)
boot.h:141: ERROR: space required after that ',' (ctx:VxV)
boot.h:141: ERROR: space required after that ',' (ctx:VxV)
boot.h:141: ERROR: space required after that ',' (ctx:VxV)
boot.h:142: ERROR: space required after that ',' (ctx:ExV)
boot.h:142: ERROR: space required after that ',' (ctx:VxV)
boot.h:142: ERROR: space required after that ',' (ctx:VxV)
boot.h:142: ERROR: space required after that ',' (ctx:VxV)
boot.h:142: ERROR: space required after that ',' (ctx:VxV)
boot.h:142: ERROR: space required after that ',' (ctx:VxV)
boot.h:143: ERROR: space required after that ',' (ctx:ExV)
boot.h:143: ERROR: space required after that ',' (ctx:VxV)
boot.h:143: ERROR: space required after that ',' (ctx:VxV)
boot.h:143: ERROR: space required after that ',' (ctx:VxV)
boot.h:143: ERROR: space required after that ',' (ctx:VxV)
boot.h:143: ERROR: space required after that ',' (ctx:VxV)
boot.h:144: ERROR: space required after that ',' (ctx:ExV)
boot.h:144: ERROR: space required after that ',' (ctx:VxV)
boot.h:144: ERROR: space required after that ',' (ctx:VxV)
boot.h:144: ERROR: space required after that ',' (ctx:VxV)
boot.h:144: ERROR: space required after that ',' (ctx:VxV)
boot.h:144: ERROR: space required after that ',' (ctx:VxV)
boot.h:145: ERROR: space required after that ',' (ctx:ExV)
boot.h:145: ERROR: space required after that ',' (ctx:VxV)
boot.h:145: ERROR: space required after that ',' (ctx:VxV)
boot.h:145: ERROR: space required after that ',' (ctx:VxV)
boot.h:145: ERROR: space required after that ',' (ctx:VxV)
boot.h:145: ERROR: space required after that ',' (ctx:VxV)
boot.h:146: ERROR: space required after that ',' (ctx:ExV)
boot.h:146: ERROR: space required after that ',' (ctx:VxV)
boot.h:146: ERROR: space required after that ',' (ctx:VxV)
boot.h:146: ERROR: space required after that ',' (ctx:VxV)
boot.h:146: ERROR: space required after that ',' (ctx:VxV)
boot.h:146: ERROR: space required after that ',' (ctx:VxV)
boot.h:147: ERROR: space required after that ',' (ctx:ExV)
boot.h:147: ERROR: space required after that ',' (ctx:VxV)
boot.h:147: ERROR: space required after that ',' (ctx:VxV)
boot.h:147: ERROR: space required after that ',' (ctx:VxV)
boot.h:147: ERROR: space required after that ',' (ctx:VxV)
boot.h:147: ERROR: space required after that ',' (ctx:VxV)
boot.h:148: ERROR: space required after that ',' (ctx:ExV)
boot.h:148: ERROR: space required after that ',' (ctx:VxV)
boot.h:148: ERROR: space required after that ',' (ctx:VxV)
boot.h:148: ERROR: space required after that ',' (ctx:VxV)
boot.h:148: ERROR: space required after that ',' (ctx:VxV)
boot.h:148: ERROR: space required after that ',' (ctx:VxV)
boot.h:149: ERROR: space required after that ',' (ctx:ExV)
boot.h:149: ERROR: space required after that ',' (ctx:VxV)
boot.h:149: ERROR: space required after that ',' (ctx:VxV)
boot.h:149: ERROR: space required after that ',' (ctx:VxV)
boot.h:149: ERROR: space required after that ',' (ctx:VxV)
boot.h:149: ERROR: space required after that ',' (ctx:VxV)
boot.h:150: ERROR: space required after that ',' (ctx:ExV)
boot.h:150: ERROR: space required after that ',' (ctx:VxV)
boot.h:150: ERROR: space required after that ',' (ctx:VxV)
boot.h:150: ERROR: space required after that ',' (ctx:VxV)
boot.h:150: ERROR: space required after that ',' (ctx:VxV)
boot.h:150: ERROR: space required after that ',' (ctx:VxV)
boot.h:151: ERROR: space required after that ',' (ctx:ExV)
boot.h:151: ERROR: space required after that ',' (ctx:VxV)
boot.h:151: ERROR: space required after that ',' (ctx:VxV)
boot.h:151: ERROR: space required after that ',' (ctx:VxV)
boot.h:151: ERROR: space required after that ',' (ctx:VxV)
boot.h:151: ERROR: space required after that ',' (ctx:VxV)
boot.h:152: ERROR: space required after that ',' (ctx:ExV)
boot.h:152: ERROR: space required after that ',' (ctx:VxV)
boot.h:152: ERROR: space required after that ',' (ctx:VxV)
boot.h:152: ERROR: space required after that ',' (ctx:VxV)
boot.h:152: ERROR: space required after that ',' (ctx:VxV)
boot.h:152: ERROR: space required after that ',' (ctx:VxV)
boot.h:153: ERROR: space required after that ',' (ctx:ExV)
boot.h:153: ERROR: space required after that ',' (ctx:VxV)
boot.h:153: ERROR: space required after that ',' (ctx:VxV)
boot.h:153: ERROR: space required after that ',' (ctx:VxV)
boot.h:153: ERROR: space required after that ',' (ctx:VxV)
boot.h:153: ERROR: space required after that ',' (ctx:VxV)
boot.h:154: ERROR: space required after that ',' (ctx:ExV)
boot.h:154: ERROR: space required after that ',' (ctx:VxV)
boot.h:154: ERROR: space required after that ',' (ctx:VxV)
boot.h:154: ERROR: space required after that ',' (ctx:VxV)
boot.h:154: ERROR: space required after that ',' (ctx:VxV)
boot.h:154: ERROR: space required after that ',' (ctx:VxV)
boot.h:155: ERROR: space required after that ',' (ctx:ExV)
boot.h:155: ERROR: space required after that ',' (ctx:VxV)
boot.h:155: ERROR: space required after that ',' (ctx:VxV)
boot.h:155: ERROR: space required after that ',' (ctx:VxV)

Signed-off-by: Aldo Iljazi <mail@aldo.io>
---
 drivers/staging/ft1000/ft1000-pcmcia/boot.h | 252 ++++++++++++++--------------
 1 file changed, 126 insertions(+), 126 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-pcmcia/boot.h b/drivers/staging/ft1000/ft1000-pcmcia/boot.h
index 9dce54e..0146cd6 100644
--- a/drivers/staging/ft1000/ft1000-pcmcia/boot.h
+++ b/drivers/staging/ft1000/ft1000-pcmcia/boot.h
@@ -27,132 +27,132 @@
 #define _BOOTH_
 
 // Official bootloader
-static unsigned char bootimage [] = {
-0x00,0x00,0x01,0x5E,0x00,0x00
-,0x00,0x00,0x00,0x00,0x02,0xD7
-,0x00,0x00,0x01,0x5E,0x46,0xB3
-,0xE6,0x02,0x00,0x98,0xE6,0x8C
-,0x00,0x98,0xFB,0x92,0xFF,0xFF
-,0x98,0xFB,0x94,0xFF,0xFF,0x98
-,0xFB,0x06,0x08,0x00,0x98,0xFB
-,0x96,0x84,0x00,0x98,0xFB,0x08
-,0x1C,0x00,0x98,0xFB,0x51,0x25
-,0x10,0x1C,0x00,0xE6,0x51,0x01
-,0x07,0xFD,0x4C,0xFF,0x20,0xF5
-,0x51,0x02,0x20,0x08,0x00,0x4C
-,0xFF,0x20,0x3C,0x00,0xC0,0x64
-,0x98,0xC0,0x66,0x98,0xC0,0x68
-,0x98,0xC0,0x6A,0x98,0xC0,0x6C
-,0x98,0x90,0x08,0x90,0x09,0x90
-,0x0A,0x90,0x0B,0x90,0x0C,0x90
-,0x0D,0x90,0x0E,0x90,0x0F,0x90
-,0x04,0x90,0x06,0xFB,0x51,0x22
-,0x16,0x08,0x03,0xFB,0x51,0x52
-,0x16,0x08,0x04,0xFB,0x51,0x24
-,0x2B,0x08,0x06,0xFB,0x51,0x54
-,0x2B,0x08,0x07,0xFB,0x51,0x24
-,0x2B,0x08,0x09,0xFB,0x51,0x54
-,0x2B,0x08,0x0A,0xFB,0x51,0x12
-,0x16,0x08,0x0C,0xFB,0x51,0x52
-,0x16,0x08,0x0D,0x78,0x00,0x00
-,0x00,0x16,0x00,0x00,0xEC,0x31
-,0xAE,0x00,0x00,0x81,0x4C,0x0F
-,0xE6,0x43,0xFF,0xEC,0x31,0x4E
-,0x00,0x00,0x91,0xEC,0x31,0xAE
-,0x00,0x00,0x91,0x4C,0x0F,0xE6
-,0x43,0xFF,0xEC,0x31,0x5E,0x00
-,0x00,0xA1,0xEB,0x31,0x08,0x00
-,0x00,0xA6,0xEB,0x31,0x08,0x00
-,0x00,0xAC,0x3C,0x00,0xEB,0x31
-,0x08,0x00,0x00,0xA8,0x76,0xFE
-,0xFE,0x08,0xEB,0x31,0x08,0x20
-,0x00,0x00,0x76,0xFF,0xFF,0x18
-,0xED,0x31,0x08,0x20,0x00,0x00
-,0x26,0x10,0x04,0x10,0xF5,0x3C
-,0x01,0x3C,0x00,0x08,0x01,0x12
-,0x3C,0x11,0x3C,0x00,0x08,0x01
-,0x0B,0x08,0x00,0x6D,0xEC,0x31
-,0xAE,0x20,0x00,0x06,0xED,0x4D
-,0x08,0x00,0x00,0x67,0x80,0x6F
-,0x00,0x01,0x0B,0x6F,0x00,0x02
-,0x2E,0x76,0xEE,0x01,0x48,0x06
-,0x01,0x39,0xED,0x4D,0x18,0x00
-,0x02,0xED,0x4D,0x08,0x00,0x04
-,0x14,0x06,0xA4,0xED,0x31,0x22
-,0x00,0x00,0xAC,0x76,0xEE,0x07
-,0x48,0x6D,0x22,0x01,0x1E,0x08
-,0x01,0x58,0xEB,0x31,0x08,0x00
-,0x00,0xAC,0x06,0xFF,0xBA,0x3C
-,0x00,0xEB,0x31,0x08,0x20,0x00
-,0x04,0x3C,0x30,0xEB,0x31,0x08
-,0x20,0x00,0x02,0x3C,0x10,0xEB
-,0x31,0x08,0x20,0x00,0x00,0xED
-,0x31,0x08,0x20,0x00,0x00,0x04
-,0x10,0xF7,0xED,0x31,0x08,0x00
-,0x00,0xA2,0x91,0x00,0x9C,0x3C
-,0x80,0xEB,0x31,0x08,0x20,0x00
-,0x04,0x3C,0x20,0xEB,0x31,0x08
-,0x20,0x00,0x02,0x3C,0x10,0xEB
-,0x31,0x08,0x20,0x00,0x00,0xED
-,0x31,0x08,0x20,0x00,0x00,0x04
-,0x10,0xF7,0xED,0x31,0x08,0x20
-,0x00,0x04,0x42,0x10,0x90,0x08
-,0xEC,0x31,0xAE,0x20,0x00,0x06
-,0xA4,0x41,0x08,0x00,0xB6,0xED
-,0x41,0x28,0x7D,0xFF,0xFF,0x22
-,0xB3,0x40,0x98,0x2A,0x32,0xEB
-,0x41,0x28,0xB4,0x43,0xFC,0x05
-,0xFF,0xE6,0xA0,0x31,0x20,0x00
-,0x06,0xEB,0x31,0x08,0x20,0x00
-,0x04,0x3C,0x20,0xEB,0x31,0x08
-,0x20,0x00,0x02,0x3C,0x10,0xEB
-,0x31,0x08,0x20,0x00,0x00,0xED
-,0x31,0x08,0x20,0x00,0x00,0x04
-,0x10,0xF7,0xED,0x31,0x08,0x20
-,0x00,0x04,0x42,0x10,0x90,0x08
-,0xEC,0x31,0xAE,0x20,0x00,0x06
-,0xA4,0x41,0x08,0x00,0x68,0xED
-,0x41,0x28,0x7D,0xFF,0xFF,0x22
-,0xB3,0x40,0x98,0x2A,0x32,0xEB
-,0x41,0x28,0xB4,0x43,0xFC,0x05
-,0xFF,0xE6,0x48,0x04,0xEB,0x31
-,0x08,0x20,0x00,0x04,0xEB,0x31
-,0x18,0x20,0x00,0x02,0x3C,0x11
-,0xEB,0x31,0x18,0x20,0x00,0x00
-,0xED,0x31,0x08,0x20,0x00,0x00
-,0x04,0x10,0xF7,0xED,0x31,0x08
-,0x20,0x00,0x02,0x66,0x00,0x6F
-,0x00,0x01,0x16,0x76,0xEE,0x06
-,0x48,0x4A,0x1E,0x48,0x04,0xED
-,0x31,0x08,0x20,0x00,0x04,0xEB
-,0x31,0x08,0x00,0x00,0xA4,0x48
-,0x04,0xED,0x31,0x08,0x20,0x00
-,0x04,0xEB,0x31,0x08,0x00,0x00
-,0xA2,0x48,0x04,0x20,0x20,0x4A
-,0x7C,0x46,0x82,0x50,0x05,0x50
-,0x15,0xB5,0x1E,0x98,0xED,0x31
-,0x08,0x00,0x00,0xA8,0x10,0x47
-,0x3B,0x2C,0x01,0xDB,0x40,0x11
-,0x98,0xC1,0x1E,0x98,0x10,0x07
-,0x30,0xF9,0x40,0x07,0x18,0x98
-,0x2A,0x10,0xEB,0x31,0x08,0x00
-,0x00,0xA8,0xA4,0x1E,0x98,0xBB
-,0x1E,0x98,0x50,0x14,0x50,0x04
-,0x46,0x83,0x48,0x04,0x02,0x01
-,0x00,0x50,0x05,0x50,0x15,0x10
-,0x87,0x3F,0x90,0x2B,0x18,0x01
-,0x00,0xC0,0x31,0x00,0x00,0xAE
-,0xDF,0x41,0x00,0x08,0x00,0x1A
-,0x42,0x11,0x67,0x01,0xDF,0x41
-,0x02,0x08,0x00,0x10,0x42,0x11
-,0x62,0x01,0xB4,0x43,0x4A,0x68
-,0x50,0x14,0x50,0x04,0x24,0x10
-,0x48,0x04,0xF2,0x31,0x00,0x01
-,0x00,0x00,0xAE,0xF6,0x31,0x00
-,0x01,0x00,0x00,0xAE,0x62,0xE4
-,0xE5,0x61,0x04,0x48,0x04,0xE5
-,0x63,0x05,0x48,0x04,0x20,0x20
-,0x00,0x00,0x00,0x00
+static unsigned char bootimage[] = {
+0x00, 0x00, 0x01, 0x5E, 0x00, 0x00,
+0x00, 0x00, 0x00, 0x00, 0x02, 0xD7,
+0x00, 0x00, 0x01, 0x5E, 0x46, 0xB3,
+0xE6, 0x02, 0x00, 0x98, 0xE6, 0x8C,
+0x00, 0x98, 0xFB, 0x92, 0xFF, 0xFF,
+0x98, 0xFB, 0x94, 0xFF, 0xFF, 0x98,
+0xFB, 0x06, 0x08, 0x00, 0x98, 0xFB,
+0x96, 0x84, 0x00, 0x98, 0xFB, 0x08,
+0x1C, 0x00, 0x98, 0xFB, 0x51, 0x25,
+0x10, 0x1C, 0x00, 0xE6, 0x51, 0x01,
+0x07, 0xFD, 0x4C, 0xFF, 0x20, 0xF5,
+0x51, 0x02, 0x20, 0x08, 0x00, 0x4C,
+0xFF, 0x20, 0x3C, 0x00, 0xC0, 0x64,
+0x98, 0xC0, 0x66, 0x98, 0xC0, 0x68,
+0x98, 0xC0, 0x6A, 0x98, 0xC0, 0x6C,
+0x98, 0x90, 0x08, 0x90, 0x09, 0x90,
+0x0A, 0x90, 0x0B, 0x90, 0x0C, 0x90,
+0x0D, 0x90, 0x0E, 0x90, 0x0F, 0x90,
+0x04, 0x90, 0x06, 0xFB, 0x51, 0x22,
+0x16, 0x08, 0x03, 0xFB, 0x51, 0x52,
+0x16, 0x08, 0x04, 0xFB, 0x51, 0x24,
+0x2B, 0x08, 0x06, 0xFB, 0x51, 0x54,
+0x2B, 0x08, 0x07, 0xFB, 0x51, 0x24,
+0x2B, 0x08, 0x09, 0xFB, 0x51, 0x54,
+0x2B, 0x08, 0x0A, 0xFB, 0x51, 0x12,
+0x16, 0x08, 0x0C, 0xFB, 0x51, 0x52,
+0x16, 0x08, 0x0D, 0x78, 0x00, 0x00,
+0x00, 0x16, 0x00, 0x00, 0xEC, 0x31,
+0xAE, 0x00, 0x00, 0x81, 0x4C, 0x0F,
+0xE6, 0x43, 0xFF, 0xEC, 0x31, 0x4E,
+0x00, 0x00, 0x91, 0xEC, 0x31, 0xAE,
+0x00, 0x00, 0x91, 0x4C, 0x0F, 0xE6,
+0x43, 0xFF, 0xEC, 0x31, 0x5E, 0x00,
+0x00, 0xA1, 0xEB, 0x31, 0x08, 0x00,
+0x00, 0xA6, 0xEB, 0x31, 0x08, 0x00,
+0x00, 0xAC, 0x3C, 0x00, 0xEB, 0x31,
+0x08, 0x00, 0x00, 0xA8, 0x76, 0xFE,
+0xFE, 0x08, 0xEB, 0x31, 0x08, 0x20,
+0x00, 0x00, 0x76, 0xFF, 0xFF, 0x18,
+0xED, 0x31, 0x08, 0x20, 0x00, 0x00,
+0x26, 0x10, 0x04, 0x10, 0xF5, 0x3C,
+0x01, 0x3C, 0x00, 0x08, 0x01, 0x12,
+0x3C, 0x11, 0x3C, 0x00, 0x08, 0x01,
+0x0B, 0x08, 0x00, 0x6D, 0xEC, 0x31,
+0xAE, 0x20, 0x00, 0x06, 0xED, 0x4D,
+0x08, 0x00, 0x00, 0x67, 0x80, 0x6F,
+0x00, 0x01, 0x0B, 0x6F, 0x00, 0x02,
+0x2E, 0x76, 0xEE, 0x01, 0x48, 0x06,
+0x01, 0x39, 0xED, 0x4D, 0x18, 0x00,
+0x02, 0xED, 0x4D, 0x08, 0x00, 0x04,
+0x14, 0x06, 0xA4, 0xED, 0x31, 0x22,
+0x00, 0x00, 0xAC, 0x76, 0xEE, 0x07,
+0x48, 0x6D, 0x22, 0x01, 0x1E, 0x08,
+0x01, 0x58, 0xEB, 0x31, 0x08, 0x00,
+0x00, 0xAC, 0x06, 0xFF, 0xBA, 0x3C,
+0x00, 0xEB, 0x31, 0x08, 0x20, 0x00,
+0x04, 0x3C, 0x30, 0xEB, 0x31, 0x08,
+0x20, 0x00, 0x02, 0x3C, 0x10, 0xEB,
+0x31, 0x08, 0x20, 0x00, 0x00, 0xED,
+0x31, 0x08, 0x20, 0x00, 0x00, 0x04,
+0x10, 0xF7, 0xED, 0x31, 0x08, 0x00,
+0x00, 0xA2, 0x91, 0x00, 0x9C, 0x3C,
+0x80, 0xEB, 0x31, 0x08, 0x20, 0x00,
+0x04, 0x3C, 0x20, 0xEB, 0x31, 0x08,
+0x20, 0x00, 0x02, 0x3C, 0x10, 0xEB,
+0x31, 0x08, 0x20, 0x00, 0x00, 0xED,
+0x31, 0x08, 0x20, 0x00, 0x00, 0x04,
+0x10, 0xF7, 0xED, 0x31, 0x08, 0x20,
+0x00, 0x04, 0x42, 0x10, 0x90, 0x08,
+0xEC, 0x31, 0xAE, 0x20, 0x00, 0x06,
+0xA4, 0x41, 0x08, 0x00, 0xB6, 0xED,
+0x41, 0x28, 0x7D, 0xFF, 0xFF, 0x22,
+0xB3, 0x40, 0x98, 0x2A, 0x32, 0xEB,
+0x41, 0x28, 0xB4, 0x43, 0xFC, 0x05,
+0xFF, 0xE6, 0xA0, 0x31, 0x20, 0x00,
+0x06, 0xEB, 0x31, 0x08, 0x20, 0x00,
+0x04, 0x3C, 0x20, 0xEB, 0x31, 0x08,
+0x20, 0x00, 0x02, 0x3C, 0x10, 0xEB,
+0x31, 0x08, 0x20, 0x00, 0x00, 0xED,
+0x31, 0x08, 0x20, 0x00, 0x00, 0x04,
+0x10, 0xF7, 0xED, 0x31, 0x08, 0x20,
+0x00, 0x04, 0x42, 0x10, 0x90, 0x08,
+0xEC, 0x31, 0xAE, 0x20, 0x00, 0x06,
+0xA4, 0x41, 0x08, 0x00, 0x68, 0xED,
+0x41, 0x28, 0x7D, 0xFF, 0xFF, 0x22,
+0xB3, 0x40, 0x98, 0x2A, 0x32, 0xEB,
+0x41, 0x28, 0xB4, 0x43, 0xFC, 0x05,
+0xFF, 0xE6, 0x48, 0x04, 0xEB, 0x31,
+0x08, 0x20, 0x00, 0x04, 0xEB, 0x31,
+0x18, 0x20, 0x00, 0x02, 0x3C, 0x11,
+0xEB, 0x31, 0x18, 0x20, 0x00, 0x00,
+0xED, 0x31, 0x08, 0x20, 0x00, 0x00,
+0x04, 0x10, 0xF7, 0xED, 0x31, 0x08,
+0x20, 0x00, 0x02, 0x66, 0x00, 0x6F,
+0x00, 0x01, 0x16, 0x76, 0xEE, 0x06,
+0x48, 0x4A, 0x1E, 0x48, 0x04, 0xED,
+0x31, 0x08, 0x20, 0x00, 0x04, 0xEB,
+0x31, 0x08, 0x00, 0x00, 0xA4, 0x48,
+0x04, 0xED, 0x31, 0x08, 0x20, 0x00,
+0x04, 0xEB, 0x31, 0x08, 0x00, 0x00,
+0xA2, 0x48, 0x04, 0x20, 0x20, 0x4A,
+0x7C, 0x46, 0x82, 0x50, 0x05, 0x50,
+0x15, 0xB5, 0x1E, 0x98, 0xED, 0x31,
+0x08, 0x00, 0x00, 0xA8, 0x10, 0x47,
+0x3B, 0x2C, 0x01, 0xDB, 0x40, 0x11,
+0x98, 0xC1, 0x1E, 0x98, 0x10, 0x07,
+0x30, 0xF9, 0x40, 0x07, 0x18, 0x98,
+0x2A, 0x10, 0xEB, 0x31, 0x08, 0x00,
+0x00, 0xA8, 0xA4, 0x1E, 0x98, 0xBB,
+0x1E, 0x98, 0x50, 0x14, 0x50, 0x04,
+0x46, 0x83, 0x48, 0x04, 0x02, 0x01,
+0x00, 0x50, 0x05, 0x50, 0x15, 0x10,
+0x87, 0x3F, 0x90, 0x2B, 0x18, 0x01,
+0x00, 0xC0, 0x31, 0x00, 0x00, 0xAE,
+0xDF, 0x41, 0x00, 0x08, 0x00, 0x1A,
+0x42, 0x11, 0x67, 0x01, 0xDF, 0x41,
+0x02, 0x08, 0x00, 0x10, 0x42, 0x11,
+0x62, 0x01, 0xB4, 0x43, 0x4A, 0x68,
+0x50, 0x14, 0x50, 0x04, 0x24, 0x10,
+0x48, 0x04, 0xF2, 0x31, 0x00, 0x01,
+0x00, 0x00, 0xAE, 0xF6, 0x31, 0x00,
+0x01, 0x00, 0x00, 0xAE, 0x62, 0xE4,
+0xE5, 0x61, 0x04, 0x48, 0x04, 0xE5,
+0x63, 0x05, 0x48, 0x04, 0x20, 0x20,
+0x00, 0x00, 0x00, 0x00
 };
 
 #endif
-- 
1.8.3.2

