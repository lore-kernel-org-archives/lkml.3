Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933402Ab3GVUxW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 16:53:22 -0400
Received: from mga14.intel.com ([143.182.124.37]:30783 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932316Ab3GVUxV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 16:53:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,721,1367996400"; 
   d="scan'208";a="271739756"
Message-ID: <51ED9BC0.6020206@linux.intel.com>
Date: Mon, 22 Jul 2013 13:53:20 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: linux-kernel@vger.kernel.org, Fengguang Wu <fengguang.wu@intel.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>, x86@kernel.org
Subject: Re: [PATCH -tip/x86/jumplabel] x86: call out into int3 handler directly
 instead of using notifier
References: <20130720131226.GA13893@localhost> <alpine.LNX.2.00.1307221307280.23128@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1307221307280.23128@pobox.suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

 What is the baseline for this patch?

	-hpa

