Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755686Ab3ALAIz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 19:08:55 -0500
Received: from mga11.intel.com ([192.55.52.93]:38926 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754923Ab3ALAIy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 19:08:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,455,1355126400"; 
   d="scan'208";a="272915142"
Message-ID: <50F0A994.5060201@linux.intel.com>
Date: Fri, 11 Jan 2013 16:08:52 -0800
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: linux-kernel@vger.kernel.org, mingo@kernel.org, hpa@zytor.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org,
        =?ISO-8859-1?Q?St=E9phane_Marchesin?= <marcheu@chromium.org>
Subject: Re: [tip:x86/urgent] x86/Sandy Bridge:  reserve pages when integrated
 graphics is present
References: <tip-a9acc5365dbda29f7be2884efb63771dc24bd815@git.kernel.org> <20130111150030.1d39b8b8@jbarnes-desktop>
In-Reply-To: <20130111150030.1d39b8b8@jbarnes-desktop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/2013 03:00 PM, Jesse Barnes wrote:
> 
> Great, thanks Peter.
> 
> Stephane, care to try this out?
> 

For the record, I can confirm that it reserves the appropriate ranges on
my personal Sandy Bridge system; I don't have any test which can provoke
the use of these pages, so I can't say I have "fully tested" this.

	-hpa

