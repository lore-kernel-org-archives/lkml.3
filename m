Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637AbaLST4y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 14:56:54 -0500
Received: from mail-ig0-f181.google.com ([209.85.213.181]:42436 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbaLST4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 14:56:52 -0500
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jonathan Richardson <jonathar@broadcom.com>
Cc: Joe Perches <joe@perches.com>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Ray Jui <rjui@broadcom.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        bcm-kernel-feedback-list@broadcom.com, devicetree@vger.kernel.org
Subject: Re: [PATCH 1/2] Input: touchscreen-iproc: Add Broadcom iProc touchscreen driver
Date: Fri, 19 Dec 2014 11:56:48 -0800
Message-ID: <3710249.R7buLtFklK@dtor-glaptop>
User-Agent: KMail/4.13.3 (Linux/3.13.0-43-generic; KDE/4.13.3; x86_64; ; )
In-Reply-To: <549481C5.7050802@broadcom.com>
References: <549481C5.7050802@broadcom.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, December 19, 2014 11:51:33 AM Jonathan Richardson wrote:
> Thanks Joe. I'll send out a new patch set with your suggestions/fixes
> shortly.

You can also drop the remove() code since we clear drvdata automatically and 
input device is managed so does not need to be unregistered explicitly.

Thanks.

-- 
Dmitry
