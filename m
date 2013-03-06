Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164Ab3CFBfD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 20:35:03 -0500
Received: from mga11.intel.com ([192.55.52.93]:30791 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750767Ab3CFBfB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 20:35:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,791,1355126400"; 
   d="scan'208";a="295481714"
Message-ID: <51369D44.6030907@linux.intel.com>
Date: Tue, 05 Mar 2013 17:35:00 -0800
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: "Yu, Fenghua" <fenghua.yu@intel.com>
CC: Dave Hansen <dave@linux.vnet.ibm.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        "bp@alien8.de" <bp@alien8.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [3.9-rc1 x86] Bug in ioremap code?
References: <201302060035.GCJ00057.FLHMOOFtJFSQOV@I-love.SAKURA.ne.jp> <201303050015.GGI39081.LOVFtOFHQOJFSM@I-love.SAKURA.ne.jp> <201303052031.JFG81705.FSOOFQHJMVFOLt@I-love.SAKURA.ne.jp> <201303060041.AIF15342.tJFOHLQFFOMVSO@I-love.SAKURA.ne.jp> <20130305180650.GD4914@pd.tnic> <201303060628.CBG00578.OJtMFFHLQVSFOO@I-love.SAKURA.ne.jp> <51366E6F.1050409@linux.intel.com> <513683DC.3070405@linux.vnet.ibm.com> <51368692.4090204@linux.intel.com> <3E5A0FA7E9CA944F9D5414FEC6C71220528C08AE@ORSMSX105.amr.corp.intel.com>
In-Reply-To: <3E5A0FA7E9CA944F9D5414FEC6C71220528C08AE@ORSMSX105.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2013 05:12 PM, Yu, Fenghua wrote:
> 
> Before setting page in 32-bit kernel boot, we load microcode. To access global variables in linear addr,  we use __pa_symbol(). There is no problem in native. Is this a problem in 32-bit guest kernel boot?
> 

Or is this tripping up the new debugging code?

	-hpa

