Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755105Ab3KKSHk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 13:07:40 -0500
Received: from mga14.intel.com ([143.182.124.37]:43197 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754205Ab3KKSHd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 13:07:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="319929577"
Message-ID: <52811DDD.3030609@linux.intel.com>
Date: Mon, 11 Nov 2013 10:11:41 -0800
From: David Cohen <david.a.cohen@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131005 Icedove/17.0.9
MIME-Version: 1.0
To: linux-kbuild@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        mmarek@suse.cz, yann.morin.1998@free.fr, rostedt@goodmis.org
Subject: make oldnoconfig fix?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Is there a plan to fix 'make oldnoconfig' option?
I currently have need to it :)
I've tracked a thread fixing 'make olddefconfig' where 'oldnoconfig'
option is reported as a known bug, right?

Br, David Cohen
