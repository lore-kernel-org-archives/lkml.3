Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751722AbaDYRqc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 13:46:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46681 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750992AbaDYRqb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 13:46:31 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, hpa@zytor.com
Cc: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 0/2] x86/boot: Small string.c cleanups
Date: Fri, 25 Apr 2014 13:46:10 -0400
Message-Id: <1398447972-27896-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hpa,

Here are two more small cleanups to boot/string.c code. This makes 
inclusion of boot/string.c at other places even simpler.

Thanks
Vivek

Vivek Goyal (2):
  x86/boot: Do not include boot.h in string.c
  x86/boot: Remove misc.h inclusion from compressed/string.c

 arch/x86/boot/compressed/string.c | 4 ----
 arch/x86/boot/string.c            | 9 ++-------
 2 files changed, 2 insertions(+), 11 deletions(-)

-- 
1.9.0

