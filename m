Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757557Ab3BRJWG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 04:22:06 -0500
Received: from intranet.asianux.com ([58.214.24.6]:9869 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357Ab3BRJWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 04:22:05 -0500
X-Spam-Score: -100.8
Message-ID: <5121F2B4.6050309@asianux.com>
Date: Mon, 18 Feb 2013 17:21:56 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
CC: sameo@linux.intel.com, Tony Lindgren <tony@atomide.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Suggestion] drivers/mfd/twl*: about power_count in twl6040_remove
References: <511F4C6B.4030805@asianux.com> <5121F161.2090503@ti.com>
In-Reply-To: <5121F161.2090503@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013年02月18日 17:16, Peter Ujfalusi 写道:
> The module can be only removed when all depending modules has been already
> removed.
> If we remove the core MFD driver we _should_ power off the chip no matter what.

  ok, thanks. it is my fault.


-- 
Chen Gang

Asianux Corporation
