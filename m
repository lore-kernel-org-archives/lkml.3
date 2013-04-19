Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757579Ab3DSIJ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 04:09:27 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:34985 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756896Ab3DSIJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 04:09:18 -0400
MIME-Version: 1.0
From: Gong Li <cescky.vp.0919@gmail.com>
Date: Fri, 19 Apr 2013 16:08:57 +0800
Message-ID: <CAGhFm1Zrwy0upyWJsxM5YT67ANZ-gXL-esbFv8AR6C3bjafTWA@mail.gmail.com>
Subject: About kernel supporting for hybrid memory
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

How to modify kernel to support for hybrid memory? I need to map text
virtual segment and data segment to the high physical memory address,
and others to the low physical memory address. How?  Any ideas?
