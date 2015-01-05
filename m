Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521AbbAEK3F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 05:29:05 -0500
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:8281 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979AbbAEK3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 05:29:01 -0500
X-IronPort-AV: E=McAfee;i="5600,1067,7671"; a="80995180"
X-IronPort-AV: E=Sophos;i="5.07,698,1413270000"; 
   d="scan'208";a="16802967"
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
CC: Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: wireless: rtlwifi: btcoexist: halbtc8821a2ant: Remove some unused functions
References: <1420230361-1862-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<54A786A4.2050202@lwfinger.net>
	<CAKXHbyOYO29uKA127qyYrCfpgQ2zoqBS9rAJME513oZ8JVdOug@mail.gmail.com>
Date: Mon, 5 Jan 2015 12:28:48 +0200
In-Reply-To: <CAKXHbyOYO29uKA127qyYrCfpgQ2zoqBS9rAJME513oZ8JVdOug@mail.gmail.com>
	(Rickard Strandqvist's message of "Sat, 3 Jan 2015 13:03:02 +0100")
Message-ID: <87d26t34in.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanexm01a.na.qualcomm.com (10.85.0.81) To
 NALASEXR01G.na.qualcomm.com (10.49.56.53)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se> writes:

>     I know that you have been told that including "net: wireless:" in the
>     subject line is discouraged. Please do not do this again. The staging
>     directory is different as GregKH uses "staging:" in the subject to route
>     patches, but wireless does not.
>
>     As to the patch, NACK for the simple reason that I am currently working on
>     a number of changes to btcoexist. Some of these routines may end up being
>     removed, but others will not. Having your patch remove them, and one of
>     mine adding them back just constitutes a lot of churning of the source. In
>     addition, it greatly increases the probability of the source trees becoming
>     unsynchronized and getting merge conflicts.
>
> I do not recognize that there has been no diskution on the subject of "net: 
> wireless:"

I mentioned about this in one your earlier patches, but I guess you
didn't get the mail because I got a bounce:

https://lkml.org/lkml/2014/12/24/222

-- 
Kalle Valo
