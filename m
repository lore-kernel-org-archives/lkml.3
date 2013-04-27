Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755740Ab3D0Mh1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Apr 2013 08:37:27 -0400
Received: from mail-a04.ithnet.com ([217.64.83.99]:58206 "HELO ithnet.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755344Ab3D0Mh0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Apr 2013 08:37:26 -0400
X-Sender-Authentication: SMTP AUTH verified <skraw>
Date: Sat, 27 Apr 2013 14:37:21 +0200
From: Stephan von Krawczynski <skraw@ithnet.com>
To: linux-kernel@vger.kernel.org
Subject: Question regarding include/linux/linkage.h (3.8.8)
Message-Id: <20130427143721.2cfda24e.skraw@ithnet.com>
Organization: ith Kommunikationstechnik GmbH
X-Mailer: Sylpheed 3.1.2 (GTK+ 2.24.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

if you look at the above file it contains:

#include <asm/linkage.h>

where should this file come from? There is no "asm" directory inside linux-3.8.8/include/ ... ?

If you need additional info please cc me.
-- 
Regards,
Stephan
