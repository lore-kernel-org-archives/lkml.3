Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751585AbaKFDEB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 22:04:01 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:65380 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931AbaKFDD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 22:03:59 -0500
Message-ID: <1415243033.5306.12.camel@marge.simpson.net>
Subject: Re: [PATCH] rtlwifi: Add more checks for get_btc_status callback
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Murilo Opsfelder Araujo <mopsfelder@gmail.com>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        Thadeu Cascardo <cascardo@cascardo.eti.br>, troy_tan@realsil.com.cn
Date: Thu, 06 Nov 2014 04:03:53 +0100
In-Reply-To: <545A6894.7040506@lwfinger.net>
References: <1414625302-3654-1-git-send-email-mopsfelder@gmail.com>
	 <5451BED0.2060906@lwfinger.net>
	 <1415178975.5402.66.camel@marge.simpson.net>
	 <545A6894.7040506@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-11-05 at 12:12 -0600, Larry Finger wrote:

> Yes, I am aware that rtl8192se is failing, and now that I am back from vacation, 
> I am working on the problem. If you want to use the driver with kernel 3.18, 
> clone the repo at http://github.com/lwfinger/rtlwifi_new.git and build and 
> install either the master or kernel_version branches. Both work.

Nah, no hurry.  My lappy is about to go on 4 weeks vacation, and has a
bulging suitcase full of kernels to wear :)

-Mike

