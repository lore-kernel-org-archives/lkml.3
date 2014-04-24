Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751696AbaDXCeQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 22:34:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18525 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751047AbaDXCeP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 22:34:15 -0400
Date: Thu, 24 Apr 2014 10:35:44 +0800
From: Dave Young <dyoung@redhat.com>
To: keescook@chromium.org
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: kaslr should avoid setup_data region
Message-ID: <20140424023544.GA2180@darkstar.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Kees

I'm worrying that setup_data regions could be overwitten by randomize
kernel base. Would you like to fix it in kaslr code?

One problem is there could be a lot of setup_data regions but current
mem_avoid is an fixed array.

Thanks
Dave
