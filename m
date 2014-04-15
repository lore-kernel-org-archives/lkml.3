Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357AbaDOSr0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 14:47:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40668 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753222AbaDOSrV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 14:47:21 -0400
Date: Tue, 15 Apr 2014 14:47:12 -0400
From: Dave Jones <davej@redhat.com>
To: linux-mm@kvack.org
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [3.15-rc1] return of bad rss-counter..
Message-ID: <20140415184712.GA24507@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, linux-mm@kvack.org,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I hoped we'd seen the last of this, but aparently not..

BUG: Bad rss-counter state mm:ffff88023fc73c00 idx:0 val:5 (Not tainted)

	Dave
