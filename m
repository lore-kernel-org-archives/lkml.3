Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933823Ab3GSGGK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 02:06:10 -0400
Received: from s3.sipsolutions.net ([144.76.43.152]:56494 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389Ab3GSGGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 02:06:08 -0400
To: Joe Perches <joe@perches.com>
Subject: Re: docproc.c:
X-PHP-Originating-Script: 0:rcmail.php
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Fri, 19 Jul 2013 08:42:39 +0300
From: Johannes Berg <johannes@sipsolutions.net>
Cc: Rob Landley <rob@landley.net>, mm-commits@vger.kernel.org,
        fengguang.wu@intel.com, linux-doc@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1374199649.1949.143.camel@joe-AO722>
References: <51e89d4a.EzMm4kY3e/JyyINM%akpm@linux-foundation.org>
 <1374199649.1949.143.camel@joe-AO722>
Message-ID: <e563de6dc20b7465431c19aa46d219cc@sipsolutions.net>
User-Agent: Roundcube Webmail/0.9.2
X-sips-origin: local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-07-19 05:07, Joe Perches wrote:
> These entries seem very arbitrary.
> (Also, I've never seen, nor cared about, them before)
> 
> Any way to autogenerate this .tmpl file?

No way that I can think of that actually makes it simpler. Sure, you 
could put a tag into each file and then use the tag, but what's the 
point? The filename is also just a tag. Also, the tmpl files actually 
contain content (if only just structure). I don't know which one links 
printk.c, but look at other ones, e.g. the 802.11 one.

johannes
