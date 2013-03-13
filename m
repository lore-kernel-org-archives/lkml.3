Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934077Ab3CMRp4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 13:45:56 -0400
Received: from mga01.intel.com ([192.55.52.88]:14582 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933096Ab3CMRpy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 13:45:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,838,1355126400"; 
   d="scan'208";a="305705468"
Message-ID: <5140BB51.2070008@linux.intel.com>
Date: Wed, 13 Mar 2013 10:45:53 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: "Yu, Fenghua" <fenghua.yu@intel.com>
CC: "dave@linux.vnet.ibm.com" <dave@linux.vnet.ibm.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [3.9-rc1] Bug in bootup code or debug code?
References: <201302060035.GCJ00057.FLHMOOFtJFSQOV@I-love.SAKURA.ne.jp><201303050015.GGI39081.LOVFtOFHQOJFSM@I-love.SAKURA.ne.jp> <201303132224.BEC60922.JStQOFMVFFOHLO@I-love.SAKURA.ne.jp> <3E5A0FA7E9CA944F9D5414FEC6C71220528C2DFF@ORSMSX105.amr.corp.intel.com>
In-Reply-To: <3E5A0FA7E9CA944F9D5414FEC6C71220528C2DFF@ORSMSX105.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a CONFIG_DEBUG_VIRTUAL configuration, isn't it?

	-hpa

