Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648Ab3COAxD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 20:53:03 -0400
Received: from intranet.asianux.com ([58.214.24.6]:51196 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511Ab3COAxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 20:53:01 -0400
X-Spam-Score: -100.8
Message-ID: <514270D2.9010205@asianux.com>
Date: Fri, 15 Mar 2013 08:52:34 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Will Deacon <will.deacon@arm.com>, nico@linaro.org, matthew.leach@arm.com,
        dave.martin@linaro.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Suggestion] Latest randconfig build errors for Head.S
References: <51415428.1070401@asianux.com> <20130314234323.GD4977@n2100.arm.linux.org.uk>
In-Reply-To: <20130314234323.GD4977@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013年03月15日 07:43, Russell King - ARM Linux 写道:
> So our wonderful toolchain has decided to start producing NULL warnings
> for every "mcr     p15, 0, rX, c7, c10, 4" instruction?  I'd just ignore
> them and hope that the toolchain people fix it.

  ok, thanks.

  :-)

-- 
Chen Gang

Asianux Corporation
